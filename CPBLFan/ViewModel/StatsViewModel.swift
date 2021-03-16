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
        if (Locale.preferredLanguages.first?.lowercased() ?? "").contains("zh-hant") {
            fetchStats()
            
        } else {
            fetchEngStats()
        }
    }
    
    func fetchStats(){
        let route = "\(APIService.CPBLSourceURL)/stats/toplist.html"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                var statsData: [Stats] = []
                let doc = try HTML(html: text, encoding: .utf8)
                
                for (index,node) in doc.css(".statstoplist_box").enumerated(){
                    let category = index.getDataCategory()
                    
                    let tag = node.css("table tr")[1]
                    var statsElement: [String] = []
                    for (index, element) in tag.css("td").enumerated(){
                        guard index > 0 else{continue}
                        statsElement.append(element.text!)
                    }
                    let moreUrl = node.at_css(".more_row")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
                    
                    statsData.append(Stats(name: statsElement[1], team: statsElement[0], stats: statsElement[2], category: category, moreUrl: moreUrl))
                }
                
                // filter pitcher data
                let pitcherSource = statsData.enumerated().filter{ return (($0.offset > 2 && $0.offset < 6) || ($0.offset > 7 && $0.offset != 10)) }.map{$0.element}
                self?.processFetched(pitcherSource, category: .pitcher)
                self?.pitcherStats.append(contentsOf: pitcherSource)
                
                // filter batter data
                let batterSource = Array(Set(statsData).subtracting(pitcherSource)).sorted(by: { ($0.category ?? "") < ($1.category ?? "")})
                self?.processFetched(batterSource, category: .batter)
                self?.batterStats.append(contentsOf: batterSource)
                
            } catch let error as NSError{
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
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
        return StatsCellViewModel(name: stat.name, team: stat.team, stats: stat.stats, category: stat.category, moreUrl: stat.moreUrl, type: type)
    }
}
