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
        
        // show loading activity
        HUD.show(.progress)
        
        // set navigator title
        self.navigationItem.title = "個人成績"
        
        // set tableview
        self.battingTableView.separatorStyle = .none
        self.battingTableView.tableFooterView = UIView()
        self.battingTableView.rowHeight = 55
        self.pitchingTableView.separatorStyle = .none
        self.pitchingTableView.tableFooterView = UIView()
        self.pitchingTableView.rowHeight = 55
        
        self.statsViewModel.fetchStats(handler: { [unowned self] data in
            let source: [[StatsViewModel]] = data.map{ value -> [StatsViewModel] in
                return value.map{ statsValue -> StatsViewModel in
                    return StatsViewModel(data: statsValue)
                }
            }

            let battingSource = source.enumerated().filter({ index, _ in
                return ((index < 3) || (index > 5 && index < 8))
            }).map{$0.1}
            
            let pitchingSource = source.enumerated().filter({ index, _ in
                return ((index > 2 && index < 6) || (index > 7))
            }).map{$0.1}
            
            self.battingTableHelper = TableViewHelper(
                tableView: self.battingTableView,
                nibName: "StatsCell",
                source: battingSource as [AnyObject],
                selectAction: nil
            )
            
            self.pitchingTableHelper = TableViewHelper(
                tableView: self.pitchingTableView,
                nibName: "StatsCell",
                source: pitchingSource as [AnyObject],
                selectAction: nil
            )
            
            HUD.hide()
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
