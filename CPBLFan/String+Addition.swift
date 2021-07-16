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
        if self.contains("ADD011") || self.contains("統一7-ELEVEn獅") {
            return "ADD011".localized()
        } else if self.contains("ACN011") || self.contains("中信兄弟") {
            return "ACN011".localized()
        } else if self.contains("AJL011") || self.contains("樂天桃猿") {
            return "AJL011".localized()
        } else if self.contains("AEO011") || self.contains("富邦悍將") {
            return "AEO011".localized()
        } else if self.contains("AAA011") || self.contains("味全龍") {
            return "AAA011".localized()
        }
        return "無"
    }
    
    func getIndex() -> Int{
        switch self {
        case "AVG", "ERA":
            return 1
        case "H", "W":
            return 7
        case "HR":
            return 11
        case "RBI":
            return 6
        case "SB", "SO":
            return 21
        case "SV":
            return 9
        case "HLD":
            return 10
        default:
            return 0
        }
    }

    var logoLocalizedString: String {
        let langeCode = Locale.preferredLanguages.first?.lowercased() ?? ""
        return self + (!langeCode.contains("zh-hant") ? "-E" : "")
    }
}
