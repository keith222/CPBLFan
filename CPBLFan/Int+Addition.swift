//
//  Int+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2021/3/16.
//  Copyright © 2021 Sparkr. All rights reserved.
//

import Foundation

extension Int {
    
    func getDataCategory() -> String{
        var category = ""
        switch self {
        case 0:
            category = "AVG"
        case 1:
            category = "H"
        case 2:
            category = "HR"
        case 3:
            category = "ERA"
        case 4:
            category = "W"
        case 5:
            category = "SV"
        case 6:
            category = "RBI"
        case 7:
            category = "SB"
        case 8:
            category = "SO"
        case 9:
            category = "WHIP"
        case 10:
            category = "TB"
        case 11:
            category = "HLD"
        default:
            break
        }
        return category
    }
    
    var monthName: String {
        switch self {
        case 1: return "January"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default: return "--"
        }
    }
}
