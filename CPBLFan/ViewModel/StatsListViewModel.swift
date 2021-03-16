//
//  StatsListViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/12.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class StatsListViewModel{
    
    private let type: PlayerType
    private let stats: Stats
    private var statsList: [StatsList] = []
    private var statsListCellViewModels: [StatsListCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?(self.statsListCellViewModels)
        }
    }
    
    var totalPage: Int = 1
    
    var category: String {
        return self.stats.category ?? ""
    }
    
    var numberOfCells: Int {
        return statsListCellViewModels.count
    }
    
    var reloadTableViewClosure: (([StatsListCellViewModel])->())?
    var errorHandleClosure: (()->())?
    
    init(with stats: Stats, and type: PlayerType){
        self.stats = stats
        self.type = type
        
        self.fetchStatList()
    }
    
    func fetchStatList(of page: Int = 1){
        let url = "\(APIService.CPBLSourceURL)\(self.stats.moreUrl ?? "")&per_page=\(page)"

        APIService.request(.get, route: url, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                var statsList: [StatsList] = []
                let doc = try HTML(html: text, encoding: .utf8)
                
                for (index,node) in doc.css(".std_tb tr").enumerated(){
                    guard index > 0 else{continue}
                    let categoryIndex = self?.stats.category?.getIndex() ?? 0
                    let numData = node.css("td")[0].text
                    let nameData = node.css("td")[1].text?.replacingOccurrences(of: "*", with: "").trimmed.components(separatedBy: " ").dropFirst().joined(separator: " ") ?? ""
                    let teamData = (node.css("td")[1].at_css("img")?["src"])?.getTeam()
                    let statsData = node.css("td")[categoryIndex].text
                    let playerUrlData = node.css("td")[1].at_css("a")?["href"]
                    statsList.append(StatsList(num: numData, name: nameData, team: teamData, stats: statsData, playerUrl: playerUrlData))
                }
                self?.statsList.append(contentsOf: statsList)
                self?.processFetched(statsList)
                
                if let page = (doc.at_css("a.page:nth-last-child(2)")?.text)?.int{
                    self?.totalPage = page
                }
                
            } catch let error as NSError{
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    func getCellViewModels() -> [StatsListCellViewModel] {
        return self.statsListCellViewModels
    }
    
    func getPlayerViewModel(with index: Int) -> PlayerViewModel {
        let player = Player(playerUrl: self.statsList[index].playerUrl, type: self.type)
        return PlayerViewModel(with: player)
    }
    
    private func getCellViewModel(with index: Int) -> StatsListCellViewModel {
        return self.statsListCellViewModels[index]
    }
    
    private func processFetched(_ statsLists: [StatsList]) {
        var viewModels = [StatsListCellViewModel]()
        for statsList in statsLists {
            viewModels.append(createCellViewModel(with: statsList))
        }
        self.statsListCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createCellViewModel(with statsList: StatsList) -> StatsListCellViewModel {
        return StatsListCellViewModel(num: statsList.num, name: statsList.name, team: statsList.team, stats: statsList.stats, playerUrl: statsList.playerUrl)
    }
}
