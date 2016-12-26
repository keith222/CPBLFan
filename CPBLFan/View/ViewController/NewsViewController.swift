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
import DynamicColor

class NewsViewController: UIViewController {
    
    
    @IBOutlet weak var newsTableView: UITableView!
    var page: Int = 0
    
    var tableViewHelper: TableViewHelper?
    
    lazy var newsViewModel = {
        return NewsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show loading activity view
        HUD.show(.progress)
        
        //set navigation bar title
        self.navigationItem.title = "CPBL Fans"
        
        //set tableview layout
        self.newsTableView.separatorStyle = .none
        self.newsTableView.estimatedRowHeight = 200
        self.newsTableView.rowHeight = UITableViewAutomaticDimension
        
        //set activity indicator in foot view
        let footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity.transform = CGAffineTransform(scaleX: 2, y: 2)
        footerView.addSubview(activity)
        footerView.isHidden = true
        self.newsTableView.tableFooterView = footerView
        activity.startAnimating()
        
        //load and show news from cpbl website
        self.newsViewModel.fetchNews(from: page, handler: { [unowned self] data in
            
            var source: [NewsViewModel] = data.map{ value -> NewsViewModel in
                return NewsViewModel(data: value)
            }
            
            //use tableview helper class to seperate uitableview delegate and datasource for reuse
            self.tableViewHelper = TableViewHelper(
                tableView: self.newsTableView,
                nibName: "NewsTableViewCell",
                source: source as [AnyObject],
                selectAction:{ [unowned self] num in
                    //closure for tableview cell tapping
                    let destion: NewsContentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
                    destion.newsUrl = data[num].newsUrl
                    destion.newsTitle = data[num].title
                    destion.newsDate = data[num].date
                    destion.newsImageUrl = data[num].imageUrl
                    self.navigationController?.pushViewController(destion, animated: true)
                },
                refreshAction:{ page in
//                  closure for refresh(load more)data
                    self.newsViewModel.fetchNews(from: (page - 1), handler: { [unowned self] data in
                        let moreSource: [NewsViewModel] = data.map{ value -> NewsViewModel in
                            return NewsViewModel(data: value)
                        }
                        source.append(contentsOf: moreSource)
                        self.tableViewHelper?.savedData = source
                    })
                }
            )
            
            footerView.isHidden = false
            
            HUD.hide(animated: true)
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Tab bar height + Navigation bar height
        let adjustForTabbarInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        self.newsTableView.contentInset = adjustForTabbarInsets
        self.newsTableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
}
