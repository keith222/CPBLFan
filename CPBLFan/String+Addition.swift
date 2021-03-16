//
//  String+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2021/3/14.
//  Copyright © 2021 Sparkr. All rights reserved.
//

import Foundation

extension String {
    
    func getTeam() -> String{
        if self.contains("B03") {
            return "B03".localized()
        } else if self.contains("A02") {
            return "A02".localized()
        } else if self.contains("AJL011") {
            return "AJL011".localized()
        } else if self.contains("E02"){
            return "E02".localized()
        } else if self.contains("L01") {
            return "L01".localized()
        } else if self.contains("B04") {
            return "B04".localized()
        } else if self.contains("D01") {
            return "D01".localized()
        }
        return "無"
    }
    
    func getIndex() -> Int{
        switch self {
        case "AVG":
            return 17
        case "H", "HIT":
            return 7
        case "HR":
            return 11
        case "ERA":
            return 15
        case "W", "WIN":
            return 8
        case "SV":
            return 10
        case "RBI":
            return 5
        case "SB":
            return 14
        case "SO":
            return 23
        case "WHIP":
            return 14
        case "TB":
            return 12
        case "HLD":
            return 12
        default:
            return 0
        }
    }

    var logoLocalizedString: String {
        let langeCode = Locale.preferredLanguages.first?.lowercased() ?? ""
        return self + (!langeCode.contains("zh-hant") ? "-E" : "")
    }
}
