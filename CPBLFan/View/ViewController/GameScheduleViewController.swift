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
    var gameSource: [[GameViewModel]]?
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
        
        // set table hide
        self.gameTableView.alpha = 0
        
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
        self.navigationItem.title = "職棒賽程"
        
        // set tableview
        self.gameTableView.rowHeight = 100
        self.gameTableView.sectionHeaderHeight = 30
        self.gameTableView.tableFooterView = UIView()
        
        // set schedule year and month
        let date = Date()
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        // because of baseball season is from 3 to 11
        if month < 3{
            year -= 1
            month = 11
        }else if month > 11{
            month = 11
        }
        
        let yearString = String(year)
        let monthString = String(month)
        
        self.gameViewModel.fetchGame(at: yearString, month: monthString, handler: { [weak self] data in
            if data != nil, data!.count > 0{
                // map cell source
                self?.gameSource = (data! as [(String,[Game])]).map{ value -> [GameViewModel] in
                    return value.1.map{ gameValue -> GameViewModel in
                        return GameViewModel(data: gameValue)
                    }
                }

                //for child change
                self?.dateLabel.text = "\(yearString) 年 \(monthString) 月"
                self?.month = Int(monthString)!
                
                // map head soruce
                let headSource: [[String]] = (data! as [(String,[Game])]).map{ value -> [String] in
                    return [yearString, monthString ,value.0]
                }
                
                self?.tableHelper = TableViewHelper(
                    tableView: (self?.gameTableView)!,
                    nibName: "GameCell",
                    source: self!.gameSource! as [AnyObject],
                    sectionCount: (self?.gameSource?.count)!,
                    sectionNib: "GameHeaderCell",
                    sectionSource: headSource as [AnyObject],
                    selectAction: { [weak self] (num,section) in
                        // closure for tableview cell tapping
                        let destination: GameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                        destination.gameViewModel = self?.gameSource?[section][num]
                        self?.navigationController?.pushViewController(destination, animated: true)
                    }
                )
  
                HUD.hide(animated: true, completion: {finished in
                    UIView.animate(withDuration: 0.1, animations: { [weak self] in
                        self?.gameTableView.alpha = 1
                    })
                })
                
                if let sectionIndex = headSource.index(where: { return $0[2] == day.string}){
                    let indexPath = IndexPath(row: 0, section: sectionIndex)
                    self?.gameTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
                
            }else{
                print("無資料")
                self?.gameTableView.alpha = 0
                HUD.hide(animated: true)
            }
        })
    }
    
    func loadData(_ year: String, month: String){
        self.dateLabel.text = "\(year) 年 \(month) 月"
        
        self.gameViewModel.fetchGame(at: year, month: month, handler: { [weak self] data in
            if data != nil, data!.count > 0{
                self?.gameSource = (data! as [(String,[Game])]).map{ value -> [GameViewModel] in
                    return value.1.map{ gameValue -> GameViewModel in
                        return GameViewModel(data: gameValue)
                    }
                }
                
                let headSource: [[String]] = (data! as [(String,[Game])]).map{ value -> [String] in
                    return [year, month ,value.0]
                }
        
                self?.tableHelper?.headSavedData = headSource as [AnyObject]
                self?.tableHelper?.savedData = self!.gameSource! as [AnyObject]
                
                HUD.hide(animated: true, completion: {finished in
                    UIView.animate(withDuration: 0.2, animations: { [weak self] in
                        self?.gameTableView.alpha = 1
                    })
                })
                
            }else{
                self?.gameTableView.alpha = 0
                
                HUD.hide(animated: true)
            }
        })
    }

    @IBAction func loadDataAction(_ sender: UIButton) {
        
        HUD.show(.progress)
        
        if sender.tag == 0{
            month -= 1
            if month < 3{
                year -= 1
                month = 11
            }
        }else{
            month += 1
            if month > 11{
                year += 1
                month = 3
            }
        }
        
        self.loadData("\(year)", month: "\(month)")
    }
    
    @objc func swipeGestureAction(gesture: UISwipeGestureRecognizer){
        HUD.show(.progress)
        
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            month -= 1
            if month < 3{
                year -= 1
                month = 11
            }
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dateLabel.transform = CGAffineTransform(translationX: ((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                self?.dateLabel.fadeOut()
            }, completion: { [weak self] _ in
                self?.dateLabel.transform = CGAffineTransform(translationX: -((self?.dateLabel.frame.width)!), y: 0)
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.dateLabel.transform = CGAffineTransform(translationX: 0, y: 0)
                    self?.dateLabel.fadeIn()
                    self?.loadData(String(self!.year), month: String(self!.month))
                })
            })
            

        case UISwipeGestureRecognizerDirection.left:
            month += 1
            if month > 11{
                year += 1
                month = 3
            }
            
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.dateLabel.transform = CGAffineTransform(translationX: -((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                self?.dateLabel.fadeOut()
                
            }, completion: { [weak self] finished in
                self?.dateLabel.transform = CGAffineTransform(translationX: ((self?.dateLabel.superview?.frame.width)! / 2), y: 0)
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
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
