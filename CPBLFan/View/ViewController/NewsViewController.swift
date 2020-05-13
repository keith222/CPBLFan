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
import Reachability

class NewsViewController: BaseViewController {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    private var tableViewHelper: TableViewHelper?
    private var presentViewControllerHelper: PresentViewControllerHelper = PresentViewControllerHelper()
    private lazy var newsViewModel = {
        return NewsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.newsViewModel.reloadTableViewClosure = { [weak self] source in
            self?.tableViewHelper?.savedData = [source as [AnyObject]]
            self?.performAnimation(of: self?.newsTableView, isHidden: source.isEmpty)
        }
        
        self.newsViewModel.errorHandleClosure = { [weak self] message in
            self?.performAlert(with: message)
        }
        
        self.tableViewHelper = TableViewHelper(
            tableView: self.newsTableView,
            nibName: IdentifierHelper.newsCell,
            selectAction: { [weak self] (num, _) in
                // closure for tableview cell tapping
                let destination: NewsContentViewController = UIStoryboard(name: IdentifierHelper.news, bundle: nil).instantiateViewController(withClass: NewsContentViewController.self)!
                destination.newsContentViewModel = self?.newsViewModel.getNewsContentViewModel(with: num)
                destination.transitioningDelegate = self
                destination.modalPresentationStyle = .fullScreen
                self?.present(destination, animated: true, completion: nil)
            },
            refreshAction: { [weak self] page in
                // closure for refresh(load more)data
                let newPage = (self?.newsViewModel.numberOfCells == 0 && page == 2) ? 0 : page - 1
                self?.newsViewModel.fetchNews(from: newPage)
            }
        )
    }
    
    private func setUp(){
        // hide navigation bar bottom border
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // set tableview
        self.newsTableView.separatorStyle = .none
        self.newsTableView.estimatedRowHeight = cellHeight()
        self.newsTableView.sectionHeaderHeight = 0
        self.newsTableView.rowHeight = UITableView.automaticDimension
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

extension NewsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPath = self.newsTableView.indexPathForSelectedRow, let selectedCell = self.newsTableView.cellForRow(at: selectedIndexPath) as? NewsCell, let selectedCellSuperview = selectedCell.superview else { return nil }
        presentViewControllerHelper.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        presentViewControllerHelper.originFrame = CGRect(
          x: presentViewControllerHelper.originFrame.origin.x + 20,
          y: presentViewControllerHelper.originFrame.origin.y + 20,
          width: presentViewControllerHelper.originFrame.size.width - 40,
          height: presentViewControllerHelper.originFrame.size.height - 40
        )
        presentViewControllerHelper.presenting = true
        return presentViewControllerHelper
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentViewControllerHelper.presenting = false
        return presentViewControllerHelper
    }
}
