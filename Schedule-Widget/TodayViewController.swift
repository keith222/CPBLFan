//
//  TodayViewController.swift
//  Schedule-Widget
//
//  Created by Yang Tun-Kai on 2017/2/26.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import NotificationCenter
import FirebaseCore

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var todayGameTableView: UITableView!
    
    private lazy var gameScheduleViewModel = {
        return GameScheduleViewModel()
    }()
    
    var tableHelper: TableViewHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
    
    private func setUp() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // set table view
        self.todayGameTableView.allowsSelection = false
        self.todayGameTableView.rowHeight = 50
        self.todayGameTableView.sectionHeaderHeight = 0
        self.todayGameTableView.tableFooterView = UIView()
        
        self.alertLabel.isHidden = true
        // add a gesture on table view and alert label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGesture:)))
        self.todayGameTableView.addGestureRecognizer(tapGesture)
        let tapGestureTwo = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGesture:)))
        self.alertLabel.addGestureRecognizer(tapGestureTwo)
        
        self.tableHelper = TableViewHelper(
            tableView: self.todayGameTableView,
            nibName: IdentifierHelper.todayGameCell
        )
        
        if #available(iOS 10, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    
    private func bindViewModel() {
        let calendar = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let month = calendar.month, month < 12, month > 2  else {
            self.alertLabel.isHidden = false
            return
        }
       
        self.gameScheduleViewModel.reloadTableViewClosure = { [weak self] gameSchedules in
            let todayGame = gameSchedules.filter({ $0.0.day == self?.gameScheduleViewModel.day })
            guard !todayGame.isEmpty else {
                self?.alertLabel.isHidden = false
                return
            }
            
            self?.alertLabel.isHidden = true
            self?.tableHelper?.savedData = [todayGame.map({ $0.1 }) as [AnyObject]]
            self?.todayGameTableView.isHidden = false
        }
        
        self.gameScheduleViewModel.updateDateClosure = { [weak self] _ in
            self?.alertLabel.isHidden = false            
        }
    }
    
    // for epanding view
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        var currentSize: CGSize = self.preferredContentSize
        switch activeDisplayMode {
        case .expanded:
            currentSize.height = 155
            self.preferredContentSize = currentSize
        case .compact:
            currentSize.height = 110
            self.preferredContentSize = maxSize
        default:
            currentSize.height = 155
            self.preferredContentSize = currentSize
        }
    }
    
    @objc private func tableViewTapped(tapGesture: UITapGestureRecognizer){
        let url: URL = URL(string: "CPBLFan://?game")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
}
