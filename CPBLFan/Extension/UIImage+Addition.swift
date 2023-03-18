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
        guard let team = team else { return UIImage(named: "logo")! }
        
        var filename = ""
        switch team {
        case _ where team.contains("味全") || team.contains("DRAGONS"):
            filename = "-1"
        case _ where team.contains("中信") || team.contains("Brothers"):
            filename = "1"
        case _ where team.contains("統一") || team.contains("U-Lions"):
            filename = "2"
        case _ where team.contains("樂天") || team.contains("Monkeys"):
            filename = "3-0"
        case _ where team.contains("富邦") || team.contains("Guardians"):
            filename = "4"
        case _ where team.contains("台鋼") || team.contains("TSG Hawks"):
            filename = "6"
        default:
            return UIImage(named: "logo")!
        }
        
        return UIImage(named: filename.logoLocalizedString)!
    }
}
