//
//  Game.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct Game: Mappable{
    
    var game: Int!
    var date: String!
    var guest: String!
    var home: String!
    var place: String!
    var g_score: String!
    var h_score: String!
    var stream: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.game <- map["game"]
        self.date <- map["date"]
        self.guest <- map["guest"]
        self.home <- map["home"]
        self.place <- map["place"]
        self.g_score <- map["g_score"]
        self.h_score <- map["h_score"]
        self.stream <- map["stream"]
    }
    
}
