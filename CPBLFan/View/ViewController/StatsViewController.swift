//
//  StatsViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/9.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD
import ReachabilitySwift
import SwifterSwift

class StatsViewController: UIViewController {

    @IBOutlet weak var statsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var battingTableView: UITableView!
    @IBOutlet weak var pitchingTableView: UITableView!
    
    var battingTableHelper: TableViewHelper?
    var pitchingTableHelper: TableViewHelper?
    
    lazy var statsViewModel = {
        return StatsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check net connection
        let reachability = Reachability()
        guard (reachability?.isReachable)! else {
            let alert = UIAlertController(title: "提示", message: "網路連線異常。")
            alert.show()
            return
        }
        
        // show loading activity
        HUD.show(.progress)
        
        // set navigator title
        self.navigationBar?.topItem?.title = "個人成績"
        
        // set tableview
        self.battingTableView.separatorStyle = .none
        self.battingTableView.tableFooterView = UIView()
        self.battingTableView.rowHeight = 55
        
        self.pitchingTableView.separatorStyle = .none
        self.pitchingTableView.tableFooterView = UIView()
        self.pitchingTableView.rowHeight = 55
        
        // load and show stats info
        self.statsViewModel.fetchStats(handler: { [unowned self] data in
            let source: [StatsViewModel] = data.map{ value -> StatsViewModel in
                return StatsViewModel(data: value)
            }
            
            // filter batting data
            let battingSource = source.enumerated().filter({ index, _ in
                return ((index < 3) || (index > 5 && index < 8) || (index == 10))
            }).map{$0.1}
            
            // filter pitch data
            let pitchingSource = source.enumerated().filter({ index, _ in
                return ((index > 2 && index < 6) || (index > 7 && index != 10))
            }).map{$0.1}
            
            // batting table
            self.battingTableHelper = TableViewHelper(
                tableView: self.battingTableView,
                nibName: "StatsCell",
                source: battingSource as [AnyObject],
                selectAction: { [unowned self] num in
                    // closure for tableview cell tapping
                    let destination: StatsListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsListViewController") as! StatsListViewController
                    destination.listUrl = battingSource[num].moreUrl
                    destination.category = battingSource[num].category
                    destination.type = .Hitter
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            )
            
            // pitching table
            self.pitchingTableHelper = TableViewHelper(
                tableView: self.pitchingTableView,
                nibName: "StatsCell",
                source: pitchingSource as [AnyObject],
                selectAction: { [unowned self] num in
                    // closure for tableview cell tapping
                    let destination: StatsListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsListViewController") as! StatsListViewController
                    destination.listUrl = pitchingSource[num].moreUrl
                    destination.category = pitchingSource[num].category
                    destination.type = .Pitcher
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            )
            
            HUD.hide(animated: true)

        })
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.battingTableView.isHidden = false
            self.pitchingTableView.isHidden = true
        case 1:
            self.battingTableView.isHidden = true
            self.pitchingTableView.isHidden = false
        default:
            break
        }
    }

}
