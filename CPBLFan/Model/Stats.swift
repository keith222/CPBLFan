//
//  Stats.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/9.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct Stats: Mappable{
    
    var name: String!
    var team: String!
    var stats: String!
    var category: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.team <- map["team"]
        self.stats <- map["stats"]
        self.category <- map["category"]
    }
    
}
