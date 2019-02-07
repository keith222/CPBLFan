//
//  RankViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper
import Kanna

class RankViewModel{
    
    var team: String!
    var win: String!
    var lose: String!
    var tie: String!
    var percentage: String!
    var gamebehind: String!
    
    init(){}
    
    init(data: Rank){
        self.team = data.team
        self.win = data.win
        self.lose = data.lose
        self.tie = data.tie
        self.percentage = data.percentage
        self.gamebehind = data.gamebehind
    }
    
    func fetchRank(from year:String, handler: @escaping (([[Rank]]?) -> ())){
        let route = "\(APIService.CPBLSourceURL)/standing/year/\(year).html"
        APIService.request(.get, route: route, completionHandler: { text in
            var ranks: [[Rank]]? = []
            
            guard let text = text else {
                handler(ranks)
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
                        rank.append(Rank(JSON: ["team":rankElement[0], "win":winLose[0], "tie":winLose[1], "lose":winLose[2], "percentage":rankElement[2], "gamebehind":rankElement[3]])!)
                    }
                    ranks?.append(rank)
                }
            } catch {
                print("error")
            }
            handler(ranks)
        })
    }
    
}
