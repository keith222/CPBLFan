//
//  StatsViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/10.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper
import Kanna

class StatsViewModel{
    
    var name: String!
    var team: String!
    var stats: String!
    var category: String!
    var moreUrl: String!
    
    init(){}
    
    init(data: Stats){
        self.name = data.name
        self.team = data.team
        self.stats = data.stats
        self.category = data.category
        self.moreUrl = data.moreUrl
    }
    
    func fetchStats(handler: @escaping (([Stats]) -> ())){
        let route = "\(APIService.CPBLSourceURL)/stats/toplist.html"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            var statsData: [Stats]? = []
            
            guard let text = text else {
                handler(statsData!)
                return
            }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                for (index,node) in doc.css(".statstoplist_box").enumerated(){
                    let category = self?.getCategory(from: index)
                    
                    let tag = node.css("table tr")[1]
                    var statsElement: [String] = []
                    for (index, element) in tag.css("td").enumerated(){
                        guard index > 0 else{continue}
                        statsElement.append(element.text!)
                    }
                    let moreUrl = node.at_css(".more_row")?["href"]?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                    
                    statsData?.append(Stats(JSON: ["category": category!,"team": statsElement[0], "name": statsElement[1], "stats": statsElement[2], "moreUrl": moreUrl!])!)
                }
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
            handler(statsData!)
        })
    }
    
    func getCategory(from index:Int) -> String{
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
