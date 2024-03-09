//
//  DateSelectCollectionViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2019/2/4.
//  Copyright © 2019 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

protocol DateSelectDelegate: AnyObject {
    func dateSelected(with year: Int, and month: Int, team: String)
}

class DateSelectCollectionViewController: UICollectionViewController {

    private var teamCode: [String] = ["all", "1", "2", "3-0", "4", "-1", "6"]
    private var teamColors: [UIColor] = [UIColor.CompromisedColors.label, .setColor(of: 0xF5B027, and: 0xF5B027), .setColor(of: 0xDD5900, and: 0xDD5900), .setColor(of: 0x651410, and: 0xAC4A44), .setColor(of: 0x001054, and: 0x257DCE), .setColor(of: 0xFF0000, and: 0xFF0000), .setColor(of: 0x0D251C, and: 0x30B584)]
    
    var year: Int?
    var month: Int?
    var team: String = "all"
    
    weak var dateSelectDelegate: DateSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let year = self.year, let month = self.month {
            self.dateSelectDelegate?.dateSelected(with: year, and: month, team: self.team)
        }
    }
    
    private func setUp() {
        // set navigation bar title
        self.navigationItem.title = "選擇年月與隊伍".localized()
       
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor.CompromisedColors.background
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
       
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: IdentifierHelper.dateCell)
        self.collectionView.allowsSelection = true
        self.collectionView.allowsMultipleSelection = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 2
        let itemWidth = (UIScreen.main.bounds.width / 4) - 4
        layout.itemSize = CGSize(width: itemWidth, height: 40)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 35)
        self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return (Date().year - 1990) + 1
        case 1: return 11
        case 2: return 7
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!
        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IdentifierHelper.dateSelectHeader, for: indexPath)
            let label = reusableview.viewWithTag(1) as! UILabel
            
            switch indexPath.section {
            case 0: label.text = "選擇年份".localized()
            case 1: label.text = "選擇月份".localized()
            case 2: label.text = "team_selection".localized()
            default: break
            }
                        
            return reusableview
        }
        
        return reusableview
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var text = ""
        if indexPath.section != 2 {
            if (Locale.preferredLanguages.first?.lowercased() ?? "").contains("zh-hant") {
                text = (indexPath.section == 0) ? "\(1990 + indexPath.row)年" : "\(2 + indexPath.row)月"
                
            } else {
                text = (indexPath.section == 0) ? "\(1990 + indexPath.row)" : (2 + indexPath.row).monthName
            }
        } else {
            text = teamCode[indexPath.row].getShortTeamByNo()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierHelper.dateCell, for: indexPath)
        cell.backgroundColor = UIColor.CompromisedColors.tertiarySystemBackground
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        
        var borderColor = UIColor.clear
        switch indexPath.section {
        case 0: borderColor = ((1990 + indexPath.row) == year) ? .darkBlue : .clear
        case 1: borderColor = ((2 + indexPath.row) == month) ? .darkBlue : .clear
        case 2: borderColor = (self.team == teamCode[indexPath.row]) ? .darkBlue : .clear
        default: break
        }
        cell.layer.borderColor = borderColor.cgColor
        
        let textColor = (indexPath.section != 2) ? UIColor.darkBlue : teamColors[indexPath.row]
        guard cell.contentView.subviews.compactMap({ $0 as? UILabel}).count == 0 else {
            let label = cell.contentView.viewWithTag(1) as! UILabel
            label.text = text
            label.textColor = textColor

            return cell
        }

        let titleLabel = UILabel(frame: cell.bounds)
        titleLabel.tag = 1
        titleLabel.textColor = textColor
        titleLabel.font.withSize(16)
        titleLabel.textAlignment = .center
        titleLabel.text = text
        cell.contentView.addSubview(titleLabel)
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0: self.year = 1990 + indexPath.row
        case 1: self.month = 2 + indexPath.row
        case 2: self.team = teamCode[indexPath.row]
        default: break
        }
        
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.layer.cornerRadius = 0
            cell.layer.borderWidth = 0
        }
        
        switch indexPath.section {
        case 0: self.year = nil
        case 1: self.month = nil
        case 2: self.team = ""
        default: break
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            view.layer.zPosition = 0
        }
    }
}
