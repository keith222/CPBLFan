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
    
    @IBOutlet weak var seasonTableView: UITableView!
    @IBOutlet weak var firstSeeasonTableView: UITableView!
    @IBOutlet weak var secondSeasonTableView: UITableView!
    
    
    lazy var rankViewModel = {
        return RankViewModel()
    }()
    
    var seasontableHelper: TableViewHelper?
    var firstSeasontableHelper: TableViewHelper?
    var secondSeasontableHelper: TableViewHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set tableview layout
        let rowHeight: CGFloat = 45.0
        let sectionHeight: CGFloat = 30.0
        self.seasonTableView.rowHeight = rowHeight
        self.seasonTableView.sectionHeaderHeight = sectionHeight
        self.firstSeeasonTableView.rowHeight = rowHeight
        self.firstSeeasonTableView.sectionHeaderHeight = sectionHeight
        self.secondSeasonTableView.rowHeight = rowHeight
        self.secondSeasonTableView.sectionHeaderHeight = sectionHeight
        
        // add tap gesture to tableview
        let seasonTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGestureRecognizer:)))
        let firstTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGestureRecognizer:)))
        let secondTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGestureRecognizer:)))
        self.seasonTableView.addGestureRecognizer(seasonTapGesture)
        self.firstSeeasonTableView.addGestureRecognizer(firstTapGesture)
        self.secondSeasonTableView.addGestureRecognizer(secondTapGesture)
        
        // extension view for ios 10 and old version
        if #available(iOS 10, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            var currentSize: CGSize = self.preferredContentSize
            currentSize = CGSize(width: currentSize.width, height: 248)
            self.preferredContentSize = currentSize
        }

        
        let date = Date()
        let calendar = Calendar.current
        
        var year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        if month < 3{
            year = year - 1
        }
        
        // load and show rank info
        self.rankViewModel.fetchRank(from: String(year) , handler: { [weak self] data in
            let source: [[RankViewModel]] = data.map{ value -> [RankViewModel] in
                return value.map{ rankValue -> RankViewModel in
                    return RankViewModel(data: rankValue)
                }
            }

            self?.seasontableHelper = TableViewHelper(
                tableView: (self?.seasonTableView)!,
                nibName: "WidgetCell",
                source: source[2] as [AnyObject],
                sectionCount: 1,
                sectionNib: "WidgetHeaderCell",
                sectionSource: nil
            )
            
            self?.firstSeasontableHelper = TableViewHelper(
                tableView: (self?.firstSeeasonTableView)!,
                nibName: "WidgetCell",
                source: source[0] as [AnyObject],
                sectionCount: 1,
                sectionNib: "WidgetHeaderCell",
                sectionSource: nil
            )
            
            self?.secondSeasontableHelper = TableViewHelper(
                tableView: (self?.secondSeasonTableView)!,
                nibName: "WidgetCell",
                source: source[1] as [AnyObject],
                sectionCount: 1,
                sectionNib: "WidgetHeaderCell",
                sectionSource: nil
            )
        })
    }
    
    // for epanding view
    @available(iOS 10, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        var currentSize: CGSize = self.preferredContentSize
        switch activeDisplayMode {
        case .expanded:
            currentSize.height = 248
            self.preferredContentSize = currentSize
        case .compact:
            self.preferredContentSize = maxSize
        }
    }
    
    @IBAction func seasonSelectionAction(_ sender: UIButton) {
        // hide tableview
        let isHidden = true
        
        switch sender.tag {
        case 0:
            self.seasonTableView.isHidden = !isHidden
            self.firstSeeasonTableView.isHidden = isHidden
            self.secondSeasonTableView.isHidden = isHidden
        case 1:
            self.seasonTableView.isHidden = isHidden
            self.firstSeeasonTableView.isHidden = !isHidden
            self.secondSeasonTableView.isHidden = isHidden
        case 2:
            self.seasonTableView.isHidden = isHidden
            self.firstSeeasonTableView.isHidden = isHidden
            self.secondSeasonTableView.isHidden = !isHidden
        default:
            break
        }
    }
    
    func tableViewTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let url: URL = URL(string: "CPBLFan://?rank")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
}
