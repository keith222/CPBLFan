//
//  News.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/25.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct News: Mappable{
    
    var title: String!
    var date: String!
    var imageUrl: String!
    var newsUrl: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.title <- map["title"]
        self.date <- map["date"]
        self.imageUrl <- map["imageUrl"]
        self.newsUrl <- map["newsUrl"]
    }
}
