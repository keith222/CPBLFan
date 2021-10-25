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
        switch self {
        case 0: return "ERA"
        case 1: return "W"
        case 2: return "SV"
        case 3: return "HLD"
        case 4: return "SO"
        case 5: return "AVG"
        case 6: return "H"
        case 7: return "HR"
        case 8: return "RBI"
        case 9: return "SB"
        default: return ""
        }
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
