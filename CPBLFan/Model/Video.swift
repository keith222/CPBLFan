//
//  Video.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/27.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import ObjectMapper

struct Video: Mappable {
    
    var videoId: String!
    var title: String!
    var imageUrl: String!
    var date: String!
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.videoId <- map["id.videoId"]
        self.title <- map["snippet.title"]
        self.imageUrl <- map["snippet.thumbnails.high.url"]
        self.date <- map["snippet.publishedAt"]
    }
}
