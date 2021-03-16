//
//  UIImage+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/8.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    class func logoImage(team: String?) -> UIImage{
        var filename = ""
        switch team {
        case "味全":
            filename = "-1"
        case "中信兄弟":
            filename = "1"
        case "統一7-ELEVEn":
            filename = "2"
        case "Lamigo":
            filename = "3"
        case "樂天":
            filename = "3-0"
        case "富邦":
            filename = "4"
        case "義大":
            filename = "4-1"
        default:
            break
        }
        
        return UIImage(named: filename.logoLocalizedString)!
    }
}
