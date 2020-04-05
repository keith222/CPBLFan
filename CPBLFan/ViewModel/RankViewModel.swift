//
//  RankViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class RankViewModel{
    
    private var ranks: [[Rank]] = []
    private var rankCellViewModels: [[RankCellViewModel]] = [] {
        didSet {
            self.reloadTableViewClosure?(rankCellViewModels, headerSource)
        }
    }
    private var headerSource: [String] {
        return self.ranks.count == 3 ? ["上半季","下半季","全年度"] : ["上半季","全年度"]
    }
    
    var numberOfCells: Int {
        return rankCellViewModels.count
    }
    
    var reloadTableViewClosure: (([[RankCellViewModel]], [String])->())?
    var errorHandleClosure: ((String?)->())?
    
    init(){
        // Load and show rank info
        self.fetchRank()
    }
    
    func fetchRank(){
        let date = Date()
        let calendar = Calendar.current
        var year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        if month < 3 { year -= 1 }
        
        let route = "\(APIService.CPBLSourceURL)/standing/year/\(year).html"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?(nil)
                return
            }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                for (_,node) in doc.css(".std_tb").enumerated(){
                    var rank: [Rank] = []
                    
                    for (index,tag) in node.css("tr").enumerated(){
                        guard index != 0 else{continue}
                        var rankElement: [String] = []
                        for (index,element) in tag.css("td").enumerated(){
                            guard index < 6 else{break}
                            guard index > 0 && index != 2 else{continue}
                            rankElement.append(element.text!)
                        }
                        
                        let winLose = rankElement[1].components(separatedBy: "-")
                        rank.append(Rank(team: rankElement[0], win: winLose[0], lose: winLose[2], tie: winLose[1], percentage: rankElement[2], gamebehind: rankElement[3]))
                    }
                    self?.ranks.append(rank)
                }
                
                self?.processFetched(self?.ranks ?? [])
                
            } catch(let error) {
                self?.errorHandleClosure?(error.localizedDescription)
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    private func processFetched(_ seasons: [[Rank]]) {
        var viewModels = [[RankCellViewModel]]()
        for season in seasons {
            var subViewModels = [RankCellViewModel]()
            for (index, rank) in season.enumerated() {
                subViewModels.append(createCellViewModel(with: rank, and: (index + 1)))
            }
            viewModels.append(subViewModels)
        }
        self.rankCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createCellViewModel(with rank: Rank, and number: Int) -> RankCellViewModel {
        return RankCellViewModel(team: rank.team, rank: number, win: rank.win, lose: rank.lose, tie: rank.tie, percentage: rank.percentage, gamebehind: rank.gamebehind)
    }
}
