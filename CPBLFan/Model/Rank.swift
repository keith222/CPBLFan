//
//  Rank.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct Rank: Mappable{
 
    var team: String!
    var win: String!
    var lose: String!
    var tie: String!
    var percentage: String!
    var gamebehind: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.team <- map["team"]
        self.win <- map["win"]
        self.lose <- map["lose"]
        self.tie <- map["tie"]
        self.percentage <- map["percentage"]
        self.gamebehind <- map["gamebehind"]
    }
}
