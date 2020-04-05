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
        fetchStats()
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
                    let category = self?.getDataCategory(from: index) ?? ""
                    
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
    
    private func getDataCategory(from index:Int) -> String{
        var category = ""
        switch index {
        case 0:
            category = "AVG"
        case 1:
            category = "H"
        case 2:
            category = "HR"
        case 3:
            category = "ERA"
        case 4:
            category = "W"
        case 5:
            category = "SV"
        case 6:
            category = "RBI"
        case 7:
            category = "SB"
        case 8:
            category = "SO"
        case 9:
            category = "WHIP"
        case 10:
            category = "TB"
        case 11:
            category = "HLD"
        default:
            break
        }
        return category
    }
    
}
