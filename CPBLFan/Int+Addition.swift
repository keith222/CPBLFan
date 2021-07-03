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
            category = "RBI"
        case 4:
            category = "SB"
        case 5:
            category = "ERA"
        case 6:
            category = "W"
        case 7:
            category = "SV"
        case 8:
            category = "HLD"
        case 9:
            category = "SO"
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
