//
//  StatsListViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/12.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper
import Kanna

class StatsListViewModel{
    
    var num: String!
    var name: String!
    var team: String!
    var stats: String!
    var playerUrl: String!
    
    init(){}
    
    init(data: StatsList){
        self.num = data.num
        self.name = data.name
        self.team = data.team
        self.stats = data.stats
        self.playerUrl = data.playerUrl
    }
    
    func fetchStatList(from category: String, route: String, page: Int = 1, handler: @escaping (([StatsList], Int?) -> ())){ 
        let url = "\(APIService.CPBLSourceURL)\(route)&per_page=\(page)"
        
        APIService.request(.get, route: url, completionHandler: { text in
            var statsList: [StatsList]? = []
            var totalPage = page
            
            if let doc = HTML(html: text, encoding: .utf8){
                for (index,node) in doc.css(".std_tb tr").enumerated(){
                    guard index > 0 else{continue}
                    let categoryIndex = self.getCategoryIndex(category: category)
                    let numData = node.css("td")[0].text
                    let nameData = node.css("td")[1].text?.replacing("*", with: "").trimmed
                    let teamData = self.getTeam(fileName: (node.css("td")[1].at_css("img")?["src"])!)
                    let statsData = node.css("td")[categoryIndex].text
                    let playerUrlData = node.css("td")[1].at_css("a")?["href"]
                    statsList?.append(StatsList(JSON: ["num": numData!, "name": nameData!, "team": teamData, "stats": statsData!, "playerUrl": playerUrlData!])!)
                }
                
                if let page = (doc.at_css("a.page:nth-last-child(2)")?.text)?.int{
                    totalPage = page
                }

            }
            handler(statsList!,totalPage)
        })
    }
    
    func getTeam(fileName: String) -> String{
        if fileName.contain("B03"){
            return "義大犀牛"
        }else if fileName.contain("A02"){
            return "Lamigo"
        }else if fileName.contain("E02"){
            return "中信兄弟"
        }else if fileName.contain("L01"){
            return "統一7-ELEVEn"
        }else if fileName.contain("B04"){
            return "富邦"
        }
        return "無"
    }
    
    func getCategoryIndex(category: String) -> Int{
        switch category {
        case "AVG":
            return 17
        case "H":
            return 7
        case "HR":
            return 11
        case "ERA":
            return 15
        case "W":
            return 8
        case "SV":
            return 10
        case "RBI":
            return 5
        case "SB":
            return 14
        case "SO":
            return 23
        case "WHIP":
            return 14
        case "TB":
            return 12
        case "HLD":
            return 12
        default:
            return 0
        }
    }
}
