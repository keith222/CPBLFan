//
//  Video.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/27.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation

struct Video: Codable {
    
    let nextPageToken: String?
    let items: [VideoItem]?
}

struct VideoItem: Codable {
    
    let id: VideoId?
    let snippet: VideoSnippet?
}

struct VideoId: Codable {
    
    let videoId: String?
}

struct VideoSnippet: Codable {
    
    let publishedAt: String?
    let title: String?
    let thumbnails: VideoThumbnails?
}

struct VideoThumbnails: Codable {
    
    let high: VideoImage
}

struct VideoImage: Codable {
    
    let url: String
}
