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
    func dateSelected(with year: Int, and month: Int)
}

class DateSelectCollectionViewController: UICollectionViewController {

    private var year: Int?
    private var month: Int?
    weak var dateSelectDelegate: DateSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    private func setUp() {
        // set navigation bar title
        self.navigationItem.title = "選擇年月".localized()
        self.navigationController?.navigationBar.barTintColor = UIColor.CompromisedColors.background
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissAction))
        self.navigationController?.navigationBar.tintColor = .darkBlue
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlue]
        }
        
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: IdentifierHelper.dateCell)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 2
        let itemWidth = (UIScreen.main.bounds.width / 4) - 4
        layout.itemSize = CGSize(width: itemWidth, height: 40)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 35)
        self.collectionView.collectionViewLayout = layout
    }

    @objc private func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return (Date().year - 1990) + 1
        case 1: return 10
        default: return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableview: UICollectionReusableView!
        if kind == UICollectionView.elementKindSectionHeader {
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: IdentifierHelper.dateSelectHeader, for: indexPath)
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = (indexPath.section == 0) ? "選擇年份".localized() : "選擇月份".localized()
            return reusableview
        }
        
        return reusableview
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var text = ""
        if (Locale.preferredLanguages.first?.lowercased() ?? "").contains("zh-hant") {
            text = (indexPath.section == 0) ? "\(1990 + indexPath.row)年" : "\(2 + indexPath.row)月"
        
        } else {
            text = (indexPath.section == 0) ? "\(1990 + indexPath.row)" : (2 + indexPath.row).monthName
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IdentifierHelper.dateCell, for: indexPath)
        cell.backgroundColor = UIColor.CompromisedColors.tertiarySystemBackground

        guard cell.contentView.subviews.compactMap({ $0 as? UILabel}).count == 0 else {
            let label = cell.contentView.viewWithTag(1) as! UILabel
            label.text = text

            return cell
        }

        let titleLabel = UILabel(frame: cell.bounds)
        titleLabel.tag = 1
        titleLabel.textColor = .darkBlue
        titleLabel.font.withSize(16)
        titleLabel.textAlignment = .center
        titleLabel.text = text
        cell.contentView.addSubview(titleLabel)
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.cornerRadius = 5
            cell.borderWidth = 2
            cell.borderColor = .darkBlue
        }
        
        if indexPath.section == 0 {
            self.year = 1990 + indexPath.row
            if let year = self.year, let month = self.month {
                self.dateSelectDelegate?.dateSelected(with: year, and: month)
                self.dismissAction()
            }
            
        } else if indexPath.section == 1 {
            self.month = 2 + indexPath.row
            if let year = self.year, let month = self.month {
                self.dateSelectDelegate?.dateSelected(with: year, and: month)
                self.dismissAction()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.layer.cornerRadius = 0
            cell.layer.borderWidth = 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            view.layer.zPosition = 0
        }
    }
}
