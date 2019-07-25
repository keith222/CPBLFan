//
//  DateSelectCollectionViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2019/2/4.
//  Copyright © 2019 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

protocol DateSelectDelegate: class {
    func dateSelected(with year: Int, and month: Int)
}

private let reuseIdentifier = "DateCell"
private let reuseHeadIdentifier = "DateSelectHeader"

class DateSelectCollectionViewController: UICollectionViewController {

    private var year: Int?
    private var month: Int?
    weak var dateSelectDelegate: DateSelectDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // set navigation bar title
        self.navigationItem.title = "選擇年月"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismissAction))
        
        
        self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        let itemWidth = (UIScreen.main.bounds.width / 4) - 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
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
            reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeadIdentifier, for: indexPath)
            let label = reusableview.viewWithTag(1) as! UILabel
            label.text = (indexPath.section == 0) ? "選擇年份" : "選擇月份"
            return reusableview
        }
        
        return reusableview
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let text = (indexPath.section == 0) ? "\(1990 + indexPath.row)年" : "\(2 + indexPath.row)月"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .white

        guard cell.contentView.subviews.compactMap({ $0 as? UILabel}).count == 0 else {
            let label = cell.contentView.viewWithTag(1) as! UILabel
            label.text = text

            return cell
        }

        let titleLabel = UILabel(frame: cell.bounds)
        titleLabel.tag = 1
        titleLabel.textColor = UIColor.darkBlue()
        titleLabel.font.withSize(16)
        titleLabel.textAlignment = .center
        titleLabel.text = text
        cell.contentView.addSubview(titleLabel)
        
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.darkBlue().cgColor
        }
        
        if indexPath.section == 0 {
            self.year = 1990 + indexPath.row
            
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
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionHeader {
            view.layer.zPosition = 0
        }
    }
}
