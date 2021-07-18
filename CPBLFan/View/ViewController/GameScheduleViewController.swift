//
//  GameScheduleViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD
import Reachability
import SwifterSwift

class GameScheduleViewController: BaseViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gameTableView: UITableView!
    
    private weak var dateSelectDelegate: DateSelectDelegate?
    private var tableHelper: TableViewHelper?
    private lazy var gameScheduleViewModel = {
        return GameScheduleViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.gameScheduleViewModel.reloadTableViewClosure = { [weak self] gameSchedules in
            
            let headers = gameSchedules.map({ $0.0 }) as [AnyObject]
            let games = gameSchedules.map({ $0.1 }) as [AnyObject]

            self?.tableHelper?.savedData = [games, headers]

            if (Locale.preferredLanguages.first?.lowercased() ?? "").contains("zh-hant") {
                self?.dateLabel.text = "\(self?.gameScheduleViewModel.year ?? 0) 年 \(self?.gameScheduleViewModel.month ?? 0) 月"
            } else {
                self?.dateLabel.text = "\(self?.gameScheduleViewModel.year ?? 0)  \(self?.gameScheduleViewModel.month.monthName ?? "")"
            }
            
            guard !games.isEmpty else {
                HUD.hide(animated: true)
                return
            }
            
            self?.performAnimation(of: self?.gameTableView, isHidden: false)
            
            if let sectionIndex = (headers as! [GameHeaderCellViewModel]).firstIndex(where: { return $0.day == self?.gameScheduleViewModel.day}){
                let indexPath = IndexPath(row: 0, section: sectionIndex)
                self?.gameTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
        
        self.gameScheduleViewModel.errorHandleClosure = { [weak self] message in
            self?.performAlert(with: message)
            self?.performAnimation(of: self?.gameTableView, isHidden: true)
        }
        
        self.gameScheduleViewModel.updateDateClosure = { [weak self] date in
            self?.dateLabel.text = date
            HUD.hide(animated: true)
        }
    }
    
    private func setUp() {
        self.dateSelectDelegate = self
        
        // set navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "filter"), style: .plain, target: self, action: #selector(self.presentToDateSelect))
        self.navigationController?.navigationBar.backgroundColor = UIColor.CompromisedColors.background
        
        // set tableview
        self.gameTableView.rowHeight = UITableView.automaticDimension
        self.gameTableView.estimatedRowHeight = 70
        self.gameTableView.sectionHeaderHeight = 35
        self.gameTableView.tableFooterView = UIView()
        
        // add left and right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureAction(gesture:)))
        rightSwipe.direction = .right
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGestureAction(gesture:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
        
        self.tableHelper = TableViewHelper(
            tableView: self.gameTableView,
            nibName: IdentifierHelper.gameCell,
            sectionNib: IdentifierHelper.gameHeaderCell,
            selectAction: { [weak self] (index, section) in
                // closure for tableview cell tapping
                let destination: GameViewController = UIStoryboard(name: IdentifierHelper.schedule, bundle: nil).instantiateViewController(withClass: GameViewController.self)!
                destination.gameViewModel = self?.gameScheduleViewModel.getGameViewModel(at: section, and: index)
                self?.navigationController?.pushViewController(destination, animated: true)
            }
        )
    }
    
    func loadData(){
        self.gameTableView.alpha = 0
        self.gameScheduleViewModel.fetchGame()
    }
    
    @objc private func presentToDateSelect() {
        let destination: DateSelectCollectionViewController = UIStoryboard(name: IdentifierHelper.schedule, bundle: nil).instantiateViewController(withClass: DateSelectCollectionViewController.self)!
        destination.dateSelectDelegate = self
        let navigationController = UINavigationController(rootViewController: destination)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func loadDataAction(_ sender: UIButton) {
        HUD.show(.progress)
        
        self.gameScheduleViewModel.updateTime(with: (sender.tag == 0) ? .previous : .next)
        self.loadData()
    }
    
    @objc func swipeGestureAction(gesture: UISwipeGestureRecognizer){
        HUD.show(.progress)
        
        self.gameScheduleViewModel.updateTime(with: (gesture.direction == .right) ? .previous : .next)
        
        let swiperAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
        let loadingAnimation = UIViewPropertyAnimator(duration: 0.3, curve: .linear)
        
        loadingAnimation.addAnimations { [weak self] in
            self?.dateLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.dateLabel.fadeIn()
            self?.loadData()
        }
        
        swiperAnimation.addAnimations { [weak self] in
            var translationX = ((self?.dateLabel.superview?.frame.width ?? 0) / 2)
            translationX *= (gesture.direction == .right) ? 1 : -1
            self?.dateLabel.transform = CGAffineTransform(translationX: translationX, y: 0)
            self?.dateLabel.fadeOut()
        }
        swiperAnimation.addCompletion({ _ in
            loadingAnimation.startAnimation()
        })
        swiperAnimation.startAnimation()
    }
}

extension GameScheduleViewController: DateSelectDelegate {
    
    func dateSelected(with year: Int, and month: Int) {
        self.gameScheduleViewModel.year = year
        self.gameScheduleViewModel.month = month
        HUD.show(.progress)
        self.loadData()
    }
}
