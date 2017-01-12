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
    
    var footerView: UIView!
    var activity: UIActivityIndicatorView!
    
    lazy var videoViewModel = {
        return VideoViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // show loading activity view
        HUD.show(.progress)
        
        self.setUp()
        
        self.videoViewModel.fetchVideos(handler: { [unowned self] (video,nextPageToken) in
            var source: [VideoViewModel] = video.map{ value -> VideoViewModel in
                return VideoViewModel(data: value)
            }
            
            //token for load next page
            self.nextPageToken = nextPageToken!
            // use tableview helper class to seperate uitableview delegate and datasource for reuse
            self.tableViewHelper = TableViewHelper(
                tableView: self.videoTableView,
                nibName: "VideoCell",
                source: source as [AnyObject],
                selectAction:{ [unowned self] num in
                    // closure for tableview cell tapping
                    let destination: VideoPlayerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
                    destination.videoId = video[num].videoId
                    self.present(destination, animated: true, completion: nil)
                },
                refreshAction:{ page in
                    // closure for refresh(load more)data
                    self.activity.startAnimating()
                    self.videoViewModel.fetchVideos(from: self.nextPageToken, handler: { [unowned self] (video,nextPageToken) in
                        let moreSource: [VideoViewModel] = video.map{ value -> VideoViewModel in
                            return VideoViewModel(data: value)
                        }
                        self.nextPageToken = nextPageToken!
                        source.append(contentsOf: moreSource)
                        self.tableViewHelper?.savedData = source
                        self.activity.stopAnimating()
                    })
                }
            )
            self.footerView.isHidden = false
            
            HUD.hide(animated: true)
        })
        
    }
    
    func setUp(){
        // set navigation bar title
        self.navigationItem.title = "影音"
        
        // set tableview layout
        self.videoTableView.separatorStyle = .none
        self.videoTableView.estimatedRowHeight = 200
        self.videoTableView.rowHeight = self.cellHeight()
        
        // set activity indicator in foot view
        footerView = UIView(frame: CGRect(x: 0, y: 5, width: self.view.bounds.size.width, height: 50))
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.frame = CGRect(x: (self.view.bounds.size.width - 44) / 2, y: 5, width: 44, height: 44)
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        footerView.addSubview(activity)
        footerView.isHidden = true
        self.videoTableView.tableFooterView = footerView
        
    }
    
    func cellHeight() -> CGFloat{
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return (UIScreen.main.bounds.size.height / CGFloat(3))
        case .phone:
            return 200
        default:
            return 200
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Tab bar height + Navigation bar height
        let adjustForTabbarInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        self.videoTableView.contentInset = adjustForTabbarInsets
        self.videoTableView.scrollIndicatorInsets = adjustForTabbarInsets
    }

}
