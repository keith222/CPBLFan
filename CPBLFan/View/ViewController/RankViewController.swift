//
//  RankViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD
import Reachability
import SwifterSwift

class RankViewController: UIViewController {
    
    @IBOutlet weak var rankTableView: UITableView!
    
    var tableHelper: TableViewHelper?
    
    lazy var rankViewModel = {
       return RankViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check net connection
        let reachability = Reachability()
        guard reachability?.connection != .none else {
            let alert = UIAlertController(title: "提示", message: "網路連線異常")
            alert.show()
            return
        }
        
        // hide tableview
        self.rankTableView.alpha = 0
        
        // show loading activity view
        HUD.show(.progress)
        
        // set navigation bar title
        self.navigationItem.title = "聯盟排名"
        
        // set tableview layout
        self.rankTableView.separatorStyle = .none
        self.rankTableView.rowHeight = 75
        self.rankTableView.sectionHeaderHeight = 70
        self.rankTableView.tableFooterView = UIView()
        
        let date = Date()
        let calendar = Calendar.current
        
        var year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        if month < 3{
            year = year - 1
        }
        
        
        // load and show rank info
        self.rankViewModel.fetchRank(from: String(year) , handler: { [weak self] data in

            guard data != nil && (data?[0].count)! > 0 else{
                HUD.hide(animated: true, completion: { finished in
                    let alert = UIAlertController(title: "提示", message: "暫無資料。")
                    alert.show()
                })
                
                return
            }
            
            let source: [[RankViewModel]] = data!.map{ value -> [RankViewModel] in
                return value.map{ rankValue -> RankViewModel in
                    return RankViewModel(data: rankValue)
                }
            }
            
            let headerSource: [String] = (source.count == 3) ? ["上半季","下半季","全年度"] : ["上半季","全年度"]
            
            
            self?.tableHelper = TableViewHelper(
                tableView: (self?.rankTableView)!,
                nibName: "RankCell",
                source: source as [AnyObject],
                sectionCount: source.count,
                sectionNib: "RankHeaderCell",
                sectionSource: headerSource as [AnyObject]
            )
            
            HUD.hide(animated: true, completion: {finished in
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.rankTableView.alpha = 1
                })
            })
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

