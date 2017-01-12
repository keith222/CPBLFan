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
    var savedData: [AnyObject] = [] {
        didSet{
            //this for refresh(load more)data
            dataSource.data = savedData
            dataSource.flag = true
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, nibName: String, source: [AnyObject], sectionCount: Int = 1, sectionNib: String? = nil, selectAction: ((Int)->())? = nil, refreshAction: ((Int)->())? = nil) {
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
        
        if sectionNib != nil{
            dataSource.templateHeader = UINib(nibName: sectionNib!, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UITableViewHeaderFooterView
            tableView.register(UINib(nibName: sectionNib!, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionNib!)
        }
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let templateCell: UITableViewCell
    var templateHeader: UITableViewHeaderFooterView?
    var sectionCount: Int = 1
    var data: [AnyObject]
    var selectAction: ((Int)->())?
    var refreshAction: ((Int)->())?
    var flag: Bool = true
    
    init(data: [AnyObject], templateCell: UITableViewCell, selectAction: ((Int)->())? = nil) {
        self.data = data
        self.templateCell = templateCell
        self.selectAction = selectAction
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionCount > 1{
            //if more than 1 section
            return data[section].count
        }else{
            return data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!)!
        if let reactiveView = cell as? BindView {
            if self.sectionCount > 1{
                //if more than 1 section
                if let datas = data[indexPath.section] as? [AnyObject], !datas.isEmpty{
                    reactiveView.bindViewModel(datas[indexPath.row])
                }
            }else{
                reactiveView.bindViewModel(data[indexPath.row])
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectAction!(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.sectionCount > 1{
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: (templateHeader?.reuseIdentifier)!)
            if let reactiveView = headerView as? BindView{
                reactiveView.bindViewModel(section)
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
    
            if (contentHeight - scrollView.frame.size.height) - offset < 44 && flag{
                page += 1
                refreshAction(page)
                flag = false
            }
        }
    }
    
}
