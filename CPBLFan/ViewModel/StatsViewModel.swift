//
//  StatsViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/10.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class StatsViewModel{
    
    private var pitcherStats: [Stats] = []
    private var batterStats: [Stats] = []
    private var pitcherStatsCellViewModels: [StatsCellViewModel] = []
    private var batterStatsCellViewModels: [StatsCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?(self.batterStatsCellViewModels)
        }
    }
    
    var numberOfPitecherCells: Int {
        return pitcherStatsCellViewModels.count
    }
    
    var numberOfBatterCells: Int {
        return batterStatsCellViewModels.count
    }
    
    var reloadTableViewClosure: (([StatsCellViewModel])->())?
    var errorHandleClosure: (()->())?
    var savedCategory: PlayerType = .batter {
        didSet {
            let cellViewModels = self.getCellViewModels(of: self.savedCategory)
            self.reloadTableViewClosure?(cellViewModels)
        }
    }
    
    init(){
        self.fetchStats()
    }
    
    func fetchStats(){
        let route = "\(APIService.CPBLSourceURL)/stats/toplist"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                var statsData: [Stats] = []
                let doc = try HTML(html: text, encoding: .utf8)
                
                for (index, node) in doc.css(".TopFiveList div.item").enumerated(){
                    let category = index.getDataCategory()
                    let categoryIndex = category.getIndex()
                    
                    let moreUrl = node.at_css(".btn_more a")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: "sortby=\(String(format: "%02d", categoryIndex - 1))", with: "sortby=\(String(format: "%02d", categoryIndex))") ?? ""
                    let topPlayerNode = node.at_css("ul li:first-child")
                    let playerData = topPlayerNode?.at_css(".player")?.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: "").split(separator: "(") ?? ["", ""]
                    let stats = topPlayerNode?.at_css(".num")?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    
                    statsData.append(Stats(name: String(playerData[0]), team: String(playerData[1]), stats: stats, category: category, moreUrl: moreUrl))
                }
                
                guard statsData.count == 10 else {
                    self?.errorHandleClosure?()
                    return
                }

                // filter batter data
                let batterSource = Array(statsData[5...9])
                self?.processFetched(batterSource, category: .batter)
                self?.batterStats.append(contentsOf: batterSource)
                
                // filter pitcher data
                let pitcherSource = Array(statsData[0...4])
                self?.processFetched(pitcherSource, category: .pitcher)
                self?.pitcherStats.append(contentsOf: pitcherSource)

            } catch let error as NSError{
                self?.errorHandleClosure?()
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    
    func getCellViewModels(of category: PlayerType) -> [StatsCellViewModel] {
        return (category == .pitcher) ? self.pitcherStatsCellViewModels : self.batterStatsCellViewModels
    }
    
    private func getCellViewModel(of category: PlayerType, at index: Int) -> StatsCellViewModel {
        return (category == .pitcher) ? self.pitcherStatsCellViewModels[index] : self.batterStatsCellViewModels[index]
    }
    
    func getStatsLivewViewModel(at index: Int) -> StatsListViewModel {
        let stats = (self.savedCategory == .pitcher) ? self.pitcherStats[index] : self.batterStats[index]
        return StatsListViewModel(with: stats, and: self.savedCategory)
    }
    
    private func processEngFetch(_ stats: [Stats?]) {
        // filter pitcher data
        let pitcherSource = stats[6..<stats.count].compactMap({ $0 })
        self.processFetched(pitcherSource, category: .pitcher)
        self.pitcherStats.append(contentsOf: pitcherSource)
        
        // filter batter data
        let batterSource = stats[0..<6].compactMap({ $0 })
        self.processFetched(batterSource, category: .batter)
        self.batterStats.append(contentsOf: batterSource)
    }
    
    private func processFetched(_ stats: [Stats], category: PlayerType) {
        var viewModels = [StatsCellViewModel]()
        for stat in stats {
            viewModels.append(createCellViewModel(with: stat, and: category))
        }
        if category == .pitcher {
            self.pitcherStatsCellViewModels.append(contentsOf: viewModels)
            
        } else {
            self.batterStatsCellViewModels.append(contentsOf: viewModels)
        }
    }
    
    private func createCellViewModel(with stat: Stats, and type: PlayerType) -> StatsCellViewModel {
        return StatsCellViewModel(name: stat.name, team: stat.team, stats: stat.stats, category: stat.category, moreUrl: stat.moreUrl)
    }
}
