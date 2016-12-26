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
    
    init(tableView: UITableView, nibName: String, source: [AnyObject], selectAction: ((Int)->())? = nil, refreshAction: ((Int)->())? = nil) {
        self.tableView = tableView
        let nib = UINib(nibName: nibName, bundle: nil)
        templateCell = nib.instantiate(withOwner: nil, options: nil)[0] as! UITableViewCell
        tableView.register(nib, forCellReuseIdentifier: templateCell.reuseIdentifier!)
        
        dataSource = DataSource(data: [], templateCell: templateCell, selectAction: nil)
        
        super.init()
        
        //set datasource variables
        dataSource.data = source
        dataSource.selectAction = selectAction!
        dataSource.refreshAction = refreshAction!
        dataSource.flag = true
        
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        self.tableView.reloadData()
    }
}

class DataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate let templateCell: UITableViewCell
    var data: [AnyObject]
    var selectAction: ((Int)->())?
    var refreshAction: ((Int)->())?
    var flag: Bool = true
    
    init(data: [AnyObject], templateCell: UITableViewCell, selectAction: ((Int)->())? = nil, refreshAction: ((Int)->())? = nil) {
        self.data = data
        self.templateCell = templateCell
        self.selectAction = selectAction
        self.refreshAction = refreshAction
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: templateCell.reuseIdentifier!)!
        if let reactiveView = cell as? BindView {
            reactiveView.bindViewModel(data[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return UIScreen.main.bounds.size.height / 3
        case .phone:
            return 200
        default:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectAction!(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
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
