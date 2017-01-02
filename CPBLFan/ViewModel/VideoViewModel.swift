//
//  VideoViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/31.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class VideoViewModel{
    
    var videoId: String?
    var title: String?
    var imageUrl: String?
    var date: String?
    
    init(){}
    
    init(data: Video){
        self.videoId = data.videoId
        self.title = data.title
        self.imageUrl = data.imageUrl
        self.date = data.date
    }
    
    func fetchVideos(from pageToken: String = "", handler: @escaping (([Video],String?)->())){
        let route = "\(APIService.YoutubeAPIURL)search?part=snippet&channelId=UCDt9GAqyRzc2e5BNxPrwZrw&maxResults=15&pageToken=\(pageToken)&key=\(APIService.YoutubeAPIKey)"
        APIService.request(.get, route: route, completionHandler: { text in
            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false){
                let json = JSON(data: dataFromString)
                let nextPageToken = json["nextPageToken"].stringValue
                
                let video = json["items"].map({ (video: (String, value: SwiftyJSON.JSON)) -> Video in
                    return Mapper<Video>().map(JSONObject: video.value.dictionaryObject!)!
                })
                handler(video, nextPageToken)
            }
            
        })
    }
}
