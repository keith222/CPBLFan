//
//  GameScheduleViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD
import ReachabilitySwift
import SwifterSwift

class GameScheduleViewController: UIViewController {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameTableView: UITableView!
    
    var tableHelper: TableViewHelper?
    
    var year: Int = 0
    var month: Int = 0

    lazy var gameViewModel = {
        return GameViewModel()
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
        
        // add left and right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureAction(gesture:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureAction(gesture:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        // show loading activity view
        HUD.show(.progress)
        
        // set navigation bar title
        self.navigationBar?.topItem?.title = "職棒賽程"
        
        // set tableview
        self.gameTableView.rowHeight = 100
        self.gameTableView.sectionHeaderHeight = 30
        self.gameTableView.allowsSelection = false
        self.gameTableView.tableFooterView = UIView()
        
        // set schedule year and month
        let date = Date()
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        // because of baseball season is from 3 to 10
        if month < 3{
            year -= 1
            month = 10
        }else if month > 10{
            month = 10
        }
        
        let yearString = String(year)
        let monthString = String(month)
        
        self.dateLabel.text = "\(yearString) 年 \(monthString) 月"
        
        self.gameViewModel.fetchGame(at: yearString, month: monthString, handler: { [weak self] data in
            
            if data != nil{
                // map cell source
                let source: [[GameViewModel]] = (data! as [(String,[Game])]).map{ value -> [GameViewModel] in
                    return value.1.map{ gameValue -> GameViewModel in
                        return GameViewModel(data: gameValue)
                    }
                }
                
                // map head soruce
                let headSource: [[String]] = (data! as [(String,[Game])]).map{ value -> [String] in
                    return [monthString ,value.0]
                }
                
                self?.gameTableView.isHidden = false
                
                self?.tableHelper = TableViewHelper(
                    tableView: (self?.gameTableView)!,
                    nibName: "GameCell",
                    source: source as [AnyObject],
                    sectionCount: (data?.count)!,
                    sectionNib: "GameHeaderCell",
                    sectionSource: headSource as [AnyObject]
                )
                
                if let sectionIndex = headSource.index(where: {return $0[1] == String(day)}){
                    let indexPath = IndexPath(row: 0, section: sectionIndex)
                    self?.gameTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }else{
                print("無資料")
                self?.gameTableView.isHidden = true
            }
            
            HUD.hide(animated: true)
        })
    }
    
    func loadData(_ year: String, month: String){
        self.dateLabel.text = "\(year) 年 \(month) 月"
        
        self.gameViewModel.fetchGame(at: year, month: month, handler: { [weak self] data in
            if data != nil{
                let source: [[GameViewModel]] = (data! as [(String,[Game])]).map{ value -> [GameViewModel] in
                    return value.1.map{ gameValue -> GameViewModel in
                        return GameViewModel(data: gameValue)
                    }
                }
                
                let headSource: [[String]] = (data! as [(String,[Game])]).map{ value -> [String] in
                    return [month ,value.0]
                }
                
                self?.gameTableView.isHidden = false
                
                self?.tableHelper?.headSavedData = headSource as [AnyObject]
                self?.tableHelper?.savedData = source as [AnyObject]
                
            }else{
                self?.gameTableView.isHidden = true
            }
            
            HUD.hide(animated: true)
        })
    }

    @IBAction func loadDataAction(_ sender: UIButton) {
        
        HUD.show(.progress)
        
        if sender.tag == 0{
            month -= 1
            if month < 3{
                year -= 1
                month = 10
            }
        }else{
            month += 1
            if month > 10{
                year += 1
                month = 3
            }
        }
        
        self.loadData("\(year)", month: "\(month)")
    }
    
    func swipeGestureAction(gesture: UISwipeGestureRecognizer){
        HUD.show(.progress)
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            month -= 1
            if month < 3{
                year -= 1
                month = 10
            }
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] _ in
                self?.dateLabel.transform = CGAffineTransform(translationX: ((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                self?.dateLabel.fadeOut()
            }, completion: { [weak self] _ in
                self?.dateLabel.transform = CGAffineTransform(translationX: -((self?.dateLabel.frame.width)!), y: 0)
                UIView.animate(withDuration: 0.2, animations: { [weak self] _ in
                    self?.dateLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self?.dateLabel.fadeIn()
                    self?.loadData(String(self!.year), month: String(self!.month))
                })
            })
            

        case UISwipeGestureRecognizerDirection.left:
            month += 1
            if month > 10{
                year += 1
                month = 3
            }
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] _ in
                self?.dateLabel.transform = CGAffineTransform(translationX: -((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                self?.dateLabel.fadeOut()
            }, completion: { [weak self] _ in
                self?.dateLabel.transform = CGAffineTransform(translationX: ((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                UIView.animate(withDuration: 0.2, animations: { [weak self] _ in
                    self?.dateLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self?.dateLabel.fadeIn()
                    self?.loadData(String(self!.year), month: String(self!.month))

                })
            })

        default:
            break
        }
    }
}
