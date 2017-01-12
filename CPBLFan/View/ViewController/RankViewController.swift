//
//  RankViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD

class RankViewController: UIViewController {
    
    @IBOutlet weak var rankTableView: UITableView!
    
    var tableHelper: TableViewHelper?
    
    lazy var rankViewModel = {
       return RankViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading activity view
        HUD.show(.progress)
        
        // set navigation bar title
        self.navigationItem.title = "聯盟排名"
        
        // set tableview layout
        self.rankTableView.separatorStyle = .none
        self.rankTableView.rowHeight = 75
        self.rankTableView.sectionHeaderHeight = 70
        self.rankTableView.tableFooterView = UIView()
        
        // load and show rank info
        self.rankViewModel.fetchRank(from: "2016", handler: { data in
            let source: [[RankViewModel]] = data.map{ value -> [RankViewModel] in
                return value.map{ rankValue -> RankViewModel in
                    return RankViewModel(data: rankValue)
                }
            }
            
            self.tableHelper = TableViewHelper(
                tableView: self.rankTableView,
                nibName: "RankCell",
                source: source as [AnyObject],
                sectionCount: 3,
                sectionNib: "RankHeaderCell"
            )
            
            HUD.hide(animated: true)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

