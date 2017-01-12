//
//  StatsList.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/12.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct StatsList: Mappable{
    
    var num: String!
    var name: String!
    var team: String!
    var stats: String!
    var playerUrl: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.num <- map["num"]
        self.name <- map["name"]
        self.team <- map["team"]
        self.stats <- map["stats"]
        self.playerUrl <- map["playerUrl"]
    }
    
}
