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
                    let moreUrl = node.at_css(".btn_more a")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    let topPlayerNode = node.at_css("ul li:first-child")
                    let playerData = topPlayerNode?.at_css(".player")?.text?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ")", with: "").split(separator: "(") ?? ["", ""]
                    let stats = topPlayerNode?.at_css(".num")?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    
                    statsData.append(Stats(name: String(playerData[0]), team: String(playerData[1]), stats: stats, category: category, moreUrl: moreUrl))
                }
                
                // filter batter data
                let batterSource = Array(statsData[0...4])
                self?.processFetched(batterSource, category: .batter)
                self?.batterStats.append(contentsOf: batterSource)
                
                // filter pitcher data
                let pitcherSource = Array(statsData[5...9])
                self?.processFetched(pitcherSource, category: .pitcher)
                self?.pitcherStats.append(contentsOf: pitcherSource)

            } catch let error as NSError{
                self?.errorHandleClosure?()
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    // not used
    func fetchEngStats() {
        let queue = DispatchGroup()
        let params = ["AVG", "HIT", "HR", "RBI", "SB", "TB", "ERA", "WIN", "SV", "SO", "WHIP", "HLD",]
        var statsData: [Stats?] = Array(repeating: nil, count: 12)
        let year = Date().year
        for (index, param) in params.enumerated() {
            queue.enter()
            let type = (index >= 6) ? "ppit" : "pbat"
            let subUrl = "/en/stats/all.html?&game_type=01&online=1&year=\(year)&stat=\(type)&sort=\(param)&order=desc"
            let route = "\(APIService.CPBLSourceURL)\(subUrl)"
            APIService.request(.get, route: route, completionHandler: { [weak self] text in
                guard let text = text else {
                    self?.errorHandleClosure?()
                    return
                }
                
                do {
                    let doc = try HTML(html: text, encoding: .utf8)
                    if let node = doc.at_css(".std_tb tr:nth-child(2)") {
                        let categoryIndex = param.getIndex()
                        let category = (index == 1 || index == 7) ? String(param.prefix(1)) : param
                        let name = node.css("td")[1].text?.replacingOccurrences(of: "*", with: "").trimmed.components(separatedBy: " ").dropFirst().joined(separator: " ") ?? ""
                        let team = (node.css("td")[1].at_css("img")?["src"])?.getTeam()
                        let stats = node.css("td")[categoryIndex].text
                        statsData[index] = Stats(name: name, team: team, stats: stats, category: category, moreUrl: subUrl)
                    }
                    
                    if !statsData.contains(nil) {
                        self?.processEngFetch(statsData)
                    }
                    
                } catch let error as NSError{
                    os_log("Error: %s", error.localizedDescription)
                }
                queue.leave()
            })
        }
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
