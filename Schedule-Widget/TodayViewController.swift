//
//  TodayViewController.swift
//  Schedule-Widget
//
//  Created by Yang Tun-Kai on 2017/2/26.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import NotificationCenter
import Firebase

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var todayGameTableView: UITableView!
    
    lazy var gameViewModel = {
        return GameViewModel()
    }()
    
    var tableHelper: TableViewHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // set table view
        self.todayGameTableView.allowsSelection = false
        self.todayGameTableView.rowHeight = 50
        
        // add a gesture on table view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped(tapGesture:)))
        self.todayGameTableView.addGestureRecognizer(tapGesture)
        
        // set schedule year, month and day
        let date = Date()
        let calendar = Calendar.current
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        
        self.gameViewModel.fetchGame(at: year, month: month, handler: { [weak self] game in
            
            // filter game by day
            if let todayGame = game?.filter({return $0.0 == day}), !todayGame.isEmpty{
                let source: [[GameViewModel]] = todayGame.map{ gameData -> [GameViewModel] in
                    return gameData.1.map{ gameValue -> GameViewModel in
                        return GameViewModel(data: gameValue)
                    }
                }
                
                // extension view for ios 10 and old version
                if #available(iOS 10, *) {
                    self?.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
                } else {
                    var currentSize: CGSize = self!.preferredContentSize
                    currentSize.height = 130
                    self!.preferredContentSize = currentSize
                }
    
                self?.tableHelper = TableViewHelper(
                    tableView: (self?.todayGameTableView)!,
                    nibName: "TodayGameCell",
                    source: source[0] as [AnyObject]
                )
                
                self?.todayGameTableView.isHidden = false
            }else{
                self?.alertLabel.isHidden = false
            }
        })
        
    }
    
    @objc func tableViewTapped(tapGesture: UITapGestureRecognizer){
        let url: URL = URL(string: "CPBLFan://?game")!
        self.extensionContext?.open(url, completionHandler: nil)
    }
    
    // for epanding view
    @available(iOS 10, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        var currentSize: CGSize = self.preferredContentSize
        switch activeDisplayMode {
        case .expanded:
            currentSize.height = 130
            self.preferredContentSize = currentSize
        case .compact:
            self.preferredContentSize = maxSize
        }
    }
    
    // for ios9
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
