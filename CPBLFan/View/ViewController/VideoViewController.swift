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
import Reachability

class VideoViewController: BaseViewController {
    
    @IBOutlet weak var videoTableView: UITableView!
    
    private var tableViewHelper: TableViewHelper?
    private var presentViewControllerHelper: PresentViewControllerHelper = PresentViewControllerHelper()
    private lazy var videoViewModel = {
        return VideoViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
       
    private func bindViewModel() {
        self.videoViewModel.reloadTableViewClosure = { [weak self] source in
            self?.tableViewHelper?.savedData = [source as [AnyObject]]
            
            self?.performAnimation(of: self?.videoTableView, isHidden: source.isEmpty)
        }
        
        self.videoViewModel.errorHandleClosure = {
            HUD.hide(animated: true, completion: { finished in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                    self?.videoTableView.alpha = 0
                })
            })
        }
        
        // load and show video from youtube
        // use tableview helper class to seperate uitableview delegate and datasource for reuse
        self.tableViewHelper = TableViewHelper(
            tableView: self.videoTableView,
            nibName: IdentifierHelper.videoCell,
            selectAction: { [weak self] (num, _) in
                // closure for tableview cell tapping
                let destination: VideoPlayerViewController = UIStoryboard(name: IdentifierHelper.video, bundle: nil).instantiateViewController(withClass: VideoPlayerViewController.self)!
                destination.videoPlayerViewModel = self?.videoViewModel.getVideoPlayerViewModel(at: num)
                destination.transitioningDelegate = self
                destination.modalPresentationStyle = .fullScreen
                self?.present(destination, animated: true, completion: nil)
                
            }, refreshAction: {[weak self] _ in
                // closure for refresh(load more)data
                self?.videoViewModel.fetchVideos()
            })

    }
    
    private func setUp(){
        // hide navigation bar bottom border
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // set tableview
        self.videoTableView.separatorStyle = .none
        self.videoTableView.estimatedRowHeight = cellHeight()
        self.videoTableView.rowHeight = UITableView.automaticDimension
        self.videoTableView.sectionHeaderHeight = 0
    }
    
    private func cellHeight() -> CGFloat{
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return (UIScreen.main.bounds.size.height / CGFloat(3))
        case .phone:
            return 200
        default:
            return 200
        }
    }
}

extension VideoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPath = self.videoTableView.indexPathForSelectedRow, let selectedCell = self.videoTableView.cellForRow(at: selectedIndexPath) as? VideoCell, let selectedCellSuperview = selectedCell.superview else { return nil }
        presentViewControllerHelper.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        presentViewControllerHelper.originFrame = CGRect(
          x: presentViewControllerHelper.originFrame.origin.x + 20,
          y: presentViewControllerHelper.originFrame.origin.y + 20,
          width: presentViewControllerHelper.originFrame.size.width - 40,
          height: presentViewControllerHelper.originFrame.size.height - 40
        )
        presentViewControllerHelper.presenting = true
        presentViewControllerHelper.isVideo = true
        return presentViewControllerHelper
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentViewControllerHelper.presenting = false
        return presentViewControllerHelper
    }
}
