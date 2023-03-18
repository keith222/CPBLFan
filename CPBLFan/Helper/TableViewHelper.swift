//
//  TableViewHelper.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/24.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import UIKit

protocol BindView {
    func bindViewModel(_ viewModel: Any)
}

class TableViewHelper: NSObject {
    
    fileprivate let tableView: UITableView
    fileprivate let templateCell: UITableViewCell
    fileprivate let dataSource: DataSource
    var savedData: [[AnyObject]?] = [] {
        didSet{
            //this for refresh(load more)data
            dataSource.data = savedData[0] ?? []
            dataSource.sectionCount = 1
        
            if savedData.count > 1 {
                dataSource.headerData = savedData[1] ?? []
                dataSource.sectionCount = savedData[1]?.count ?? 0
            }
            dataSource.flag = true
            tableView.reloadData()
        }
    }
    var headSavedData: [AnyObject] = [] {
        didSet{
            //this for refresh(load more)data
            dataSource.headerData = headSavedData
            dataSource.sectionCount = headSavedData.count
        }
    }
    
    init(tableView: UITableView, nibName: String, source: [AnyObject] = [], sectionCount: Int = 0, sectionNib: String? = nil, sectionSource: [AnyObject]? = nil, selectAction: ((Int,Int)->())? = nil, refreshAction: ((Int)->())? = nil) {
        self.tableView = tableView
        let nib = UINib(nibName: nibName, bundle: nil)
        templateCell = nib.instantiate(withOwner: nil, options: nil)[0] as! UITableViewCell
        tableView.register(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
        
        dataSource = DataSource(data: [], templateCell: templateCell, selectAction: nil)
        
        super.init()
        
        //set datasource variables
        dataSource.data = source
        dataSource.selectAction = selectAction
        dataSource.refreshAction = refreshAction
        dataSource.flag = true
        dataSource.sectionCount = sectionCount
        
        if let sectionNib = sectionNib{
            dataSource.templateHeader = UINib(nibName: sectionNib, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UITableViewHeaderFooterView
            dataSource.headerData = sectionSource
            tableView.register(UINib(nibName: sectionNib, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionNib)
        }
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        
        guard !source.isEmpty else { return }
        
        self.tableView.reloadData()
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var hasAnimatedAllCells = false
    private let templateCell: UITableViewCell
    var templateHeader: UITableViewHeaderFooterView?
    var sectionCount: Int = 0
    var data: [AnyObject]
    var headerData: [AnyObject]?
    var selectAction: ((Int,Int)->())?
    var refreshAction: ((Int)->())?
    var flag: Bool = true
        
    init(data: [AnyObject], templateCell: UITableViewCell, selectAction: ((Int,Int)->())? = nil) {
        self.data = data
        self.templateCell = templateCell
        self.selectAction = selectAction
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count == 0 { return 0 }
        
        if let datas = data[section] as? [AnyObject], !datas.isEmpty {
            return datas.count
            
        } else {
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!)!
        
        if let reactiveView = cell as? BindView {
            if let datas = data[indexPath.section] as? [AnyObject], !datas.isEmpty{
                reactiveView.bindViewModel(datas[indexPath.row])
            } else {
                reactiveView.bindViewModel(data[indexPath.row])
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !hasAnimatedAllCells else { return }
        
        cell.alpha = 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.05 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
        
        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectAction?(indexPath.row,indexPath.section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let templateHeader = self.templateHeader {
            let reuseIdentifier = templateHeader.reuseIdentifier
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: (reuseIdentifier)!)
            if let reactiveView = headerView as? BindView, let headerData = headerData, !headerData.isEmpty{
                    reactiveView.bindViewModel(headerData[section])
            }
            return headerView
        }else{
            return nil
        }
    }
        
    var page = 1
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //if tableview can refresh(load more) data
        if let refreshAction = self.refreshAction{
            let offset = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
    
            if (contentHeight - scrollView.frame.size.height) - offset < 55 && flag{
                page += 1
                refreshAction(page)
                flag = false
            }
        }
    }

}
