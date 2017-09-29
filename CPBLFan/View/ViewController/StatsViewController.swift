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
        
        self.battingTableView.alpha = 0
        
        // show loading activity
        HUD.show(.progress)
        
        // set navigator title
        self.navigationItem.title = "個人成績"
        
        // set tableview
        self.battingTableView.separatorStyle = .none
        self.battingTableView.tableFooterView = UIView()
        self.battingTableView.rowHeight = 55
        self.battingTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        self.pitchingTableView.separatorStyle = .none
        self.pitchingTableView.tableFooterView = UIView()
        self.pitchingTableView.rowHeight = 55
        self.pitchingTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        // load and show stats info
        self.statsViewModel.fetchStats(handler: { [unowned self] data in
            let source: [StatsViewModel] = data.map{ value -> StatsViewModel in
                return StatsViewModel(data: value)
            }
            
            // filter batting data
            let battingSource = source.enumerated().filter({ return (($0.offset < 3) || ($0.offset > 5 && $0.offset < 8) || ($0.offset == 10))
            }).map{$0.element}
            
            // filter pitch data
            let pitchingSource = source.enumerated().filter{ return (($0.offset > 2 && $0.offset < 6) || ($0.offset > 7 && $0.offset != 10)) }.map{$0.element}
            
            // batting table
            self.battingTableHelper = TableViewHelper(
                tableView: self.battingTableView,
                nibName: "StatsCell",
                source: battingSource as [AnyObject],
                selectAction: { [unowned self] (num,_) in
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
                selectAction: { [unowned self] (num,_) in
                    // closure for tableview cell tapping
                    let destination: StatsListViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatsListViewController") as! StatsListViewController
                    destination.listUrl = pitchingSource[num].moreUrl
                    destination.category = pitchingSource[num].category
                    destination.type = .Pitcher
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            )
            
            HUD.hide(animated: true, completion: {finished in
                UIView.animate(withDuration: 0.3, animations: {
                    self.battingTableView.alpha = 1
                })
            })
            

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
