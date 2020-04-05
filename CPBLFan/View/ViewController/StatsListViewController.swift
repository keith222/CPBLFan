//
//  StatsListViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/12.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD

class StatsListViewController: BaseViewController {

    @IBOutlet weak var statsListTableView: UITableView!
    
    private var footerView: UIView?
    private var activity: UIActivityIndicatorView?
    private var tableViewHelper: TableViewHelper?
    
    var statsListViewModel: StatsListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading activity view
        HUD.show(.progress)
        
        self.setUp()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.statsListViewModel?.reloadTableViewClosure = { [weak self] source in
            self?.tableViewHelper?.savedData = [source as [AnyObject]]
            self?.activity?.stopAnimating()
            
            guard !source.isEmpty else {
                self?.performAnimation(of: self?.statsListTableView, isHidden: true)
                return
            }
        
            self?.statsListTableView.alpha = 1
            self?.footerView?.isHidden = false
            
            HUD.hide(animated: true)
        }
        
        self.statsListViewModel?.errorHandleClosure = {
            HUD.hide(animated: true, completion: { finished in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                    self?.statsListTableView.alpha = 0
                })
            })
        }
        
        self.title = self.statsListViewModel?.category

        self.tableViewHelper = TableViewHelper(
            tableView: self.statsListTableView,
            nibName: IdentifierHelper.statsListCell,
            selectAction: { [weak self] (num,_) in
                let destination: PlayerViewController = UIStoryboard(name: IdentifierHelper.statistics, bundle: nil).instantiateViewController(withClass: PlayerViewController.self)!
                destination.playerViewModel = self?.statsListViewModel?.getPlayerViewModel(with: num)
                self?.navigationController?.pushViewController(destination, animated: true)
            },
            refreshAction: { [weak self] page in
                // closure for refresh(load more)data
                if page <= self?.statsListViewModel?.totalPage ?? 0 {
                    self?.activity?.startAnimating()
                    self?.statsListViewModel?.fetchStatList(of: page)
                    
                } else {
                    // remove footer view if it is last page
                    self?.statsListTableView.removeTableFooterView()
                }
            }
        )
    }
    
    private func setUp(){
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
          
        // set tableview layout
        self.statsListTableView.separatorStyle = .none
        self.statsListTableView.rowHeight = 55
        self.statsListTableView.sectionHeaderHeight = UITableView.automaticDimension
        
        // set activity indicator in foot view
        footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        activity = UIActivityIndicatorView(style: .gray)
        activity?.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        footerView?.addSubview(activity!)
        footerView?.isHidden = true
        self.statsListTableView.tableFooterView = footerView
    }

}
