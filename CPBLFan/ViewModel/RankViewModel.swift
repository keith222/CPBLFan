//
//  RankViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import os
import FirebaseCore
import FirebaseDatabase

class RankViewModel{
    
    private let ref: DatabaseReference = Database.database().reference()
    private let headerSource: [String] = ["上半季", "下半季", "全年度"]
    private var ranks: [[Rank]] = []
    private var rankCellViewModels: [[RankCellViewModel]] = [] {
        didSet {
            self.reloadTableViewClosure?(rankCellViewModels, headerSource)
        }
    }
   
    var numberOfCells: Int {
        return rankCellViewModels.count
    }
    var reloadTableViewClosure: (([[RankCellViewModel]], [String])->())?
    var errorHandleClosure: ((String?)->())?
    
    init(){
        // Load and show rank info
        self.fetchRankNew()
    }
    
    func fetchRankNew(){
        ref.child("rank").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            // check data if existed
            guard let data = snapshot.children.allObjects as? [DataSnapshot], !data.isEmpty else {
                self?.rankCellViewModels = [[], [], []]
                return
            }
            
            do {
                // convert firebase data to dictionary
                let jsonDictionary = data.compactMap({ ($0.key, ($0.value as? [AnyObject])) })
                    .reduce(into: [String: [AnyObject]](), { $0.updateValue($1.1, forKey: $1.0) })
                
                // data jsonalize
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
                let season = try JSONDecoder().decode(Season.self, from: jsonData)
                
                self?.ranks.append(season.first.sorted(by: { $0.displayRank < $1.displayRank  }))
                self?.ranks.append(season.second.sorted(by: { $0.displayRank < $1.displayRank }))
                self?.ranks.append(season.full.sorted(by: { $0.displayRank < $1.displayRank }))
                
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
            for rank in season {
                subViewModels.append(createCellViewModel(with: rank))
            }
            viewModels.append(subViewModels)
        }
        self.rankCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createCellViewModel(with rank: Rank) -> RankCellViewModel {
        return RankCellViewModel(team: rank.team, rank: rank.rank, win: rank.win, lose: rank.lose, tie: rank.tie, winningRate: rank.winningRate, gamebehind: rank.gameBehind)
    }
}
