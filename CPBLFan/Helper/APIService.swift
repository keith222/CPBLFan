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
    static let CPBLsourceURL: String = "http://www.cpbl.com.tw"
    
    static func request(_
        method: Alamofire.HTTPMethod,
        route: String,
        completionHandler: @escaping(String)->()
    ){
        Alamofire.request(
            "\(APIService.CPBLsourceURL)\(route)",
            method: .get
            ).responseString(completionHandler: { response in
                completionHandler(response.result.value!)
            })
    }
}
