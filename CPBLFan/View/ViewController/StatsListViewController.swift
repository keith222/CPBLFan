//
//  StatsListViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/12.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import PKHUD

class StatsListViewController: UIViewController {

    @IBOutlet weak var statsListTableView: UITableView!
    
    var listUrl: String!
    var category: String!
    var type: playerType!
    var footerView: UIView!
    var activity: UIActivityIndicatorView!
    var tableHelper: TableViewHelper?
    
    lazy var statsListViewModel = {
        return StatsListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // show loading activity view
        HUD.show(.progress)
        
        self.setUp()
        
        self.statsListViewModel.fetchStatList(from: self.category, route: self.listUrl, handler: { [weak self] (stats, totalPage) in
            var source: [StatsListViewModel] = stats.map{ value -> StatsListViewModel in
                return StatsListViewModel(data: value)
            }
            
            self?.tableHelper = TableViewHelper(
                tableView: (self?.statsListTableView)!,
                nibName: "StatsListCell",
                source: source,
                selectAction: { num in
                    let destination: PlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
                    destination.playerUrl = source[num].playerUrl
                    destination.type = self?.type
                    self?.navigationController?.pushViewController(destination, animated: true)
                },
                refreshAction: { page in
                    // closure for refresh(load more)data
                    if page <= totalPage!{
                        self?.activity.startAnimating()
                        self?.statsListViewModel.fetchStatList(from: (self?.category)!, route: (self?.listUrl)!, page: page, handler:{ [weak self] (stats, totalPage) in
                            let moreSource: [StatsListViewModel] = stats.map{ value -> StatsListViewModel in
                                return StatsListViewModel(data: value)
                            }

                            source.append(contentsOf: moreSource)
                            self?.tableHelper?.savedData = source
                            self?.activity.stopAnimating()
                        })
                    }else{
                        // remove footer view if it is last page
                        self?.statsListTableView.removeTableFooterView()
                    }
                }
            )
            
            self?.footerView.isHidden = false
            
            HUD.hide(animated: true)
            self?.statsListTableView.isHidden = false
        })

    }
    
    func setUp(){
        // hide tableview
        self.statsListTableView.isHidden = true
        
        // set navigation bar
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.noTitleBarButtonItem()
        
        self.title = self.category
        
        // set tableview layout
        self.statsListTableView.separatorStyle = .none
        self.statsListTableView.rowHeight = 55
        
        // set activity indicator in foot view
        footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        footerView.addSubview(activity)
        footerView.isHidden = true
        self.statsListTableView.tableFooterView = footerView
    }

}
