//
//  String+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2021/3/14.
//  Copyright © 2021 Sparkr. All rights reserved.
//

import Foundation
import SwifterSwift

extension String {
    
    func getTeam() -> String {
        if self.contains("ADD011") || self.contains("統一7-ELEVEn獅") || self.contains("U-Lions") {
            return "ADD011".localized()
        } else if self.contains("ACN011") || self.contains("中信兄弟") || self.contains("Brothers") {
            return "ACN011".localized()
        } else if self.contains("AJL011") || self.contains("樂天桃猿") || self.contains("Monkeys") {
            return "AJL011".localized()
        } else if self.contains("AEO011") || self.contains("富邦悍將") || self.contains("Guardians") {
            return "AEO011".localized()
        } else if self.contains("AAA011") || self.contains("味全龍") || self.contains("DRAGONS") {
            return "AAA011".localized()
        } else if self.contains("AKP011") || self.contains("台鋼雄鷹") || self.contains("TSG Hawks") {
            return "AKP011".localized()
        }
        return "無"
    }
    
    func getTeamByNo() -> String {
        switch self {
        case "-1": return "AAA011".localized()
        case "1": return "ACN011".localized()
        case "2": return "ADD011".localized()
        case "3-0": return "AJL011".localized()
        case "4": return "AEO011".localized()
        case "6": return "AKP011".localized()
        default: return "--"
        }
    }
    
    func getShortTeamByNo() -> String {
        switch self {
        case "-1": return "AAA011_short".localized()
        case "1": return "ACN011_short".localized()
        case "2": return "ADD011_short".localized()
        case "3-0": return "AJL011_short".localized()
        case "4": return "AEO011_short".localized()
        case "6": return "AKP011_short".localized()
        case "all": return "all".localized()
        default: return "--"
        }
    }
    
    func getIndex() -> Int{
        if self == "AVG" || self == "ERA" {
            return 1
        } else if self == "H" || self == "W" {
            return 7
        } else if self == "HR" {
            return 11
        } else if self == "RBI" {
            return 6
        } else if self == "SB" || self == "SO" {
            return 21
        } else if self == "SV" {
            return 9
        } else if self == "HLD" {
            return 10
        }
        
        return 0
    }
    
    var logoLocalizedString: String {
        let langeCode = Locale.preferredLanguages.first?.lowercased() ?? ""
        return self + (langeCode.contains("en") ? "-E" : "")
    }
}
