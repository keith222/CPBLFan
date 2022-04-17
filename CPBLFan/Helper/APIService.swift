//
//  APIService.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/23.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import Foundation
import Alamofire

class APIService{
    
    //url of cpbl web site
    static let CPBLSourceURL: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["CPBLSourceURL"]!
    static let CPBLSourceEnURL: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["CPBLSourceEnURL"]!
    //url of youtube api
    static let YoutubeAPIURL: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["YoutubeAPIURL"]!
    //youtube api key
    static let YoutubeAPIKey: String = (Bundle.main.object(forInfoDictionaryKey: "API Service") as! Dictionary<String, String>)["YoutubeAPIKey"]!
    
    static func request(_ method: Alamofire.HTTPMethod, route: String, parameters: Parameters? = nil, completionHandler: @escaping(String?)->()){
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = 5
        manager.session.configuration.timeoutIntervalForResource = 5
        manager.request(route, method: method, parameters: parameters).responseString(completionHandler: { response in
            switch response.result {
            case .success:
                completionHandler(response.value)
                
            case .failure:
                completionHandler(nil)
            }
        })
    }
}
