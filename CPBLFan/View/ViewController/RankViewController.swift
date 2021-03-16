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

class RankViewController: BaseViewController {
    
    @IBOutlet weak var rankTableView: UITableView!
    
    var tableHelper: TableViewHelper?
    
    private lazy var rankViewModel = {
       return RankViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }

    private func bindViewModel() {
        self.rankViewModel.reloadTableViewClosure = { [weak self] (source, header) in
            guard !(source.first?.isEmpty ?? true) else{
                self?.performAnimation(of: self?.rankTableView, isHidden: true)
                return
            }

            self?.tableHelper?.savedData = [source as [AnyObject], header as [AnyObject]]
            self?.rankTableView.alpha = 1
            
            HUD.hide(animated: true)
        }
        
        self.rankViewModel.errorHandleClosure = { [weak self] message in
            self?.performAlert(with: message)
        }
    }

    private func setUp() {
        // set tableview layout
        self.rankTableView.rowHeight = 70
        self.rankTableView.sectionHeaderHeight = 60
        self.rankTableView.tableFooterView = UIView()
        
        self.tableHelper = TableViewHelper(
            tableView: self.rankTableView,
            nibName: IdentifierHelper.rankCell,
            sectionNib: IdentifierHelper.rankHeaderCell
        )
    }
}

