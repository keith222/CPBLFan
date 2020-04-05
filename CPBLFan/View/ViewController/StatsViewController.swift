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
import Reachability

class StatsViewController: BaseViewController {

    @IBOutlet weak var statsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var batterPitcherTableView: UITableView!

    private var tableViewHelper: TableViewHelper?
    private lazy var statsViewModel = {
        return StatsViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        self.setUp()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.statsViewModel.reloadTableViewClosure = { [weak self] source in
            self?.tableViewHelper?.savedData = [source as [AnyObject]]
    
            self?.performAnimation(of: self?.batterPitcherTableView, isHidden: source.isEmpty)
        }
        
        self.statsViewModel.errorHandleClosure = {
            HUD.hide(animated: true, completion: { finished in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                    self?.batterPitcherTableView.alpha = 0
                })
            })
        }
        
        // load and show stats info
        self.tableViewHelper = TableViewHelper(
            tableView: self.batterPitcherTableView,
            nibName: IdentifierHelper.statsCell,
            selectAction: { [weak self] (num,_) in
                // closure for tableview cell tapping
                let destination: StatsListViewController = UIStoryboard(name: IdentifierHelper.statistics, bundle: nil).instantiateViewController(withClass: StatsListViewController.self)!
                destination.statsListViewModel = self?.statsViewModel.getStatsLivewViewModel(at: num)
                self?.navigationController?.pushViewController(destination, animated: true)
            }
        )
    }
    
    private func setUp() {
        // set navigation bar
        self.navigationController?.navigationBar.backgroundColor = UIColor.CompromisedColors.background
        
        // set tableview
        self.batterPitcherTableView.separatorStyle = .none
        self.batterPitcherTableView.tableFooterView = UIView()
        self.batterPitcherTableView.rowHeight = 55
        self.batterPitcherTableView.sectionHeaderHeight = UITableView.automaticDimension
    }
     
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.statsViewModel.savedCategory = (sender.selectedSegmentIndex == 0) ? .batter : .pitcher
    }

}
