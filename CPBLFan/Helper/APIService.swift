//
//  APIService.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/23.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService{
    
    //url of cpbl web site
    static let CPBLSourceURL: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["CPBLSourceURL"]!
    //url of youtube api
    static let YoutubeAPIURL: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["YoutubeAPIURL"]!
    //youtube api key
    static let YoutubeAPIKey: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["YoutubeAPIKey"]!
    
    static func request(_
        method: Alamofire.HTTPMethod,
        route: String,
        completionHandler: @escaping(String?)->()
    ){
        Alamofire.request(
            route,
            method: .get
            ).responseString(completionHandler: { response in
                completionHandler(response.result.value)
            })
    }
}
