//
//  News.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/25.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation

struct News{
    
    var title: String
    var date: String
    var imageUrl: String
    var newsUrl: String
    
    init(title: String, date: String, imageUrl: String, newsUrl: String ) {
        self.title = title
        self.date = date
        self.imageUrl = imageUrl
        self.newsUrl = newsUrl
    }
}
