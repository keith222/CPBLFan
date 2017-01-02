//
//  VideoViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/29.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import DynamicColor

class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoTableView: UITableView!
    var nextPageToken: String = ""
    
    var tableViewHelper: TableViewHelper?
    
    lazy var videoViewModel = {
        return VideoViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        //show loading activity view
        HUD.show(.progress)
        
        //set navigation bar title
        self.navigationItem.title = "影音"
        
        //set tableview layout
        self.videoTableView.separatorStyle = .none
        self.videoTableView.estimatedRowHeight = 200
        self.videoTableView.rowHeight = UITableViewAutomaticDimension
        
        //set activity indicator in foot view
        let footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        let activity: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        footerView.addSubview(activity)
        footerView.isHidden = true
        self.videoTableView.tableFooterView = footerView
        activity.startAnimating()
        
        self.videoViewModel.fetchVideos(handler: { [unowned self] (video,nextPageToken) in
            var source: [VideoViewModel] = video.map{ value -> VideoViewModel in
                return VideoViewModel(data: value)
            }
            
            //token for load next page
            self.nextPageToken = nextPageToken!
            //use tableview helper class to seperate uitableview delegate and datasource for reuse
            self.tableViewHelper = TableViewHelper(
                tableView: self.videoTableView,
                nibName: "VideoCell",
                source: source as [AnyObject],
                selectAction:{ [unowned self] num in
                    //closure for tableview cell tapping
//                    let destion: NewsContentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
                    print(video[num].videoId)
                    
                },
                refreshAction:{ page in
                    //closure for refresh(load more)data
                    self.videoViewModel.fetchVideos(from: self.nextPageToken, handler: { [unowned self] (video,nextPageToken) in
                        let moreSource: [VideoViewModel] = video.map{ value -> VideoViewModel in
                            return VideoViewModel(data: value)
                        }
                        self.nextPageToken = nextPageToken!
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
        self.videoTableView.contentInset = adjustForTabbarInsets
        self.videoTableView.scrollIndicatorInsets = adjustForTabbarInsets
    }

}
