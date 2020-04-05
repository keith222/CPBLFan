//
//  TodayViewController.swift
//  Rank-Widget
//
//  Created by Yang Tun-Kai on 2017/2/25.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var seasonTableView: UITableView!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    private var seasontableHelper: TableViewHelper?
    private var seasonRankCellViewModel: [RankCellViewModel] = []
    private var firstSeasonRankCellViewModel: [RankCellViewModel] = []
    private var secondSeasonRankCellViewModel: [RankCellViewModel] = []
    
    private lazy var rankViewModel = {
        return RankViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
    
    private func setUp() {
        // set tableview layout
        self.seasonTableView.rowHeight = 45
        self.seasonTableView.sectionHeaderHeight = 30
        self.seasonTableView.isHidden = true
        
        self.alertLabel.isHidden = true
        
        self.categoryButtons.first?.isSelected = true
        self.categoryButtons.first?.backgroundColor = .darkBlue
        
        // add tap gesture to tableview
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGestureRecognizer:)))
        self.seasonTableView.addGestureRecognizer(tapGesture)
                
        self.seasontableHelper = TableViewHelper(
            tableView: self.seasonTableView,
            nibName: IdentifierHelper.widgetCell,
            sectionNib: IdentifierHelper.widgetHeaderCell
        )
        
        if #available(iOS 10, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    
    private func bindViewModel() {
        self.rankViewModel.reloadTableViewClosure = { [weak self] (source, header) in
            guard !source.isEmpty, !source[0].isEmpty else {
                self?.alertLabel.isHidden = false
                return
            }
            
            let seasonData = (source.count == 3) ? source[2] : source[1]
            self?.firstSeasonRankCellViewModel = source[0]
            self?.seasonRankCellViewModel = seasonData
            self?.secondSeasonRankCellViewModel = (source.count == 3) ? source[1] : []
            self?.seasontableHelper?.savedData = [seasonData as [AnyObject]]
            self?.seasonTableView.isHidden = false
            self?.alertLabel.isHidden = true
        }
    }
    
    // for epanding view
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        var currentSize: CGSize = self.preferredContentSize
        switch activeDisplayMode {
        case .expanded:
            currentSize.height = 248
            self.preferredContentSize = currentSize
        case .compact:
            currentSize.height = 115
            self.preferredContentSize = maxSize
        default:
            currentSize.height = 248
            self.preferredContentSize = currentSize
        }
    }
    
    @IBAction func seasonSelectionAction(_ sender: UIButton) {
        var data = [AnyObject]()
        
        categoryButtons.forEach({
            $0.backgroundColor = ($0 == sender) ? .darkBlue : UIColor(white: 1, alpha: 0.5)
            $0.isSelected = ($0 == sender)
        })

        switch sender.tag {
        case 0:
            data = self.seasonRankCellViewModel as [AnyObject]

        case 1:
            data = self.firstSeasonRankCellViewModel as [AnyObject]
            
        case 2:
            data = self.secondSeasonRankCellViewModel as [AnyObject]
            
        default:
            break
        }
        
        self.seasontableHelper?.savedData = [data]
    }
    
    @objc func tableViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        if let url: URL = URL(string: "CPBLFan://?rank") {
            self.extensionContext?.open(url, completionHandler: nil)
        }
    }
}
