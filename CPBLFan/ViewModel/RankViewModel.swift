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
    
    private var ranks: [[Rank]?] = [[Rank]?](repeating: nil, count: 3)
    private var rankCellViewModels: [[RankCellViewModel]] = [] {
        didSet {
            self.reloadTableViewClosure?(rankCellViewModels, headerSource)
        }
    }
    private var headerSource: [String] {
        switch self.ranks.count {
        case 2: return ["上半季", "全年度"]
        case 3: return ["上半季", "下半季", "全年度"]
        default: return ["上半季"]
        }
    }
    private let route = "\(APIService.CPBLSourceURL)/standings"
    
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
        let month = calendar.component(.month, from: date)
        
        if month < 3 {
            let year = calendar.component(.year, from: date) - 1
            self.fetchLastYearRank(with: year)
        } else {
            self.fetchCurrentRank()
        }
    }
    
    private func fetchCurrentRank() {
        let queue = DispatchGroup()
    
        for season in 0...2 { // SeaosnCode => 0: All, 1: 1st half, 2: 2nd half
            let param = ["SeasonCode": season]            
            queue.enter()
            var rank = [Rank]()
            APIService.request(.post, route: "\(route)/season", parameters: param, completionHandler: { [weak self] text in
                guard let text = text else {
                    self?.errorHandleClosure?(nil)
                    return
                }
                
                do {
                    let doc = try HTML(html: text, encoding: .utf8)
                    if let node = doc.at_css(".RecordTable:first-child") {
                        for (index, tag) in node.css("tr").enumerated() {
                            guard index != 0 else { continue }
                            var rankElement: [String] = []
                            
                            for (index, element) in tag.css("td").enumerated(){
                                guard index <= 4 else{ break }
                                guard index != 1 else { continue }
                                
                                if index == 0 {
                                    let team = element.at_css(".team-w-trophy")?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                    rankElement.append(team)
                                    continue
                                }
                                rankElement.append(element.text ?? "")
                            }
                            
                            let winLose = rankElement[1].components(separatedBy: "-")
                            rank.append(Rank(team: rankElement[0], win: winLose[0], lose: winLose[2], tie: winLose[1], percentage: rankElement[2], gamebehind: rankElement[3]))
                        }
                        guard !rank.isEmpty else {
                            queue.leave()
                            return
                        }
                        
                        var index = 0
                        switch season {
                        case 0: index = 2
                        case 1: index = 0
                        default: index = season
                        }
                        self?.ranks[index] = rank
                    }
                } catch(let error) {
                    self?.errorHandleClosure?(error.localizedDescription)
                    os_log("Error: %s", error.localizedDescription)
                }
                queue.leave()
            })
        }
        
        queue.notify(queue: .main, execute: { [weak self] in
            self?.ranks.removeAll(where: { $0 == nil })
            self?.processFetched(self?.ranks ?? [])
        })
    }
    
    private func fetchLastYearRank(with year: Int) {
        APIService.request(.post, route: "\(route)/history", parameters: ["Year": year], completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?(nil)
                return
            }

            do {
                let doc = try HTML(html: text, encoding: .utf8)

                for (index, node) in doc.css(".RecordTable").enumerated(){
                    var rank: [Rank] = []

                    for (index,tag) in node.css("tr").enumerated(){
                        guard index != 0 else { continue }
                        var rankElement: [String] = []
                        
                        for (index, element) in tag.css("td").enumerated(){
                            guard index <= 4 else{ break }
                            guard index != 1 else { continue }
                            
                            if index == 0 {
                                let team = element.at_css(".team-w-trophy")?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                rankElement.append(team)
                                continue
                            }
                            rankElement.append(element.text ?? "")
                        }
                        
                        let winLose = rankElement[1].components(separatedBy: "-")
                        rank.append(Rank(team: rankElement[0], win: winLose[0], lose: winLose[2], tie: winLose[1], percentage: rankElement[2], gamebehind: rankElement[3]))
                    }
                    self?.ranks[index] = rank
                }
                self?.processFetched(self?.ranks ?? [])

            } catch(let error) {
                self?.errorHandleClosure?(error.localizedDescription)
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    private func processFetched(_ seasons: [[Rank]?]) {
        var viewModels = [[RankCellViewModel]]()
        
        for season in seasons {
            guard let season = season else { continue }
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
