//
//  SeasonRankIntent.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/2.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import Foundation
import AppIntents
import WidgetKit
import SwifterSwift

struct TabButtonIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Tab Button Intent"
    
    @Parameter(title: "Season Number", default: 2)
    var seasonNumber: Int
    
    init() {}
    
    init(seasonNumber: Int) {
        self.seasonNumber = seasonNumber
    }
    
    func perform() async throws -> some IntentResult {
        UserDefaults.standard.setValue(seasonNumber, forKey: "selectedSeason")
        return .result()
    }
}
