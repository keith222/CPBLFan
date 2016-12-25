//
//  NewsViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/23.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class NewsViewController: UIViewController {
    
    
    @IBOutlet weak var newsTableView: UITableView!
    var page: Int = 0
    
    var tableViewHelper: TableViewHelper?
    
    lazy var newsViewModel = {
        return NewsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
        
        self.navigationItem.title = "CPBL Fans"
        
        self.newsViewModel.fetchNews(from: page, handler: { [unowned self] data in
            
            let source: [NewsViewModel] = data.map{ value -> NewsViewModel in
                return NewsViewModel(data: value)
            }
            
            self.tableViewHelper = TableViewHelper(
                tableView: self.newsTableView,
                nibName: "NewsTableViewCell",
                source: source as [AnyObject],
                selectAction:{ [unowned self] num in
                    let destion: NewsContentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
                    
                    destion.newsUrl = data[num].newsUrl
                    destion.newsTitle = data[num].title
                    destion.newsDate = data[num].date
                    destion.newsImageUrl = data[num].imageUrl
                    self.navigationController?.pushViewController(destion, animated: true)
                }
            )
            
            HUD.hide(animated: true)
        })
        
        self.newsTableView.separatorStyle = .none
        self.newsTableView.estimatedRowHeight = 200
        self.newsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Tab bar height + Navigation bar height
        let adjustForTabbarInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        self.newsTableView.contentInset = adjustForTabbarInsets
        self.newsTableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
}
