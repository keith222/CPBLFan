//
//  CPBLFanWidgetBundle.swift
//  CPBLFanWidget
//
//  Created by Yang Tun-Kai on 2024/2/28.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct CPBLFanWidgetBundle: WidgetBundle {
    
    var body: some Widget {
        TodayGameWidget()
        TeamGameWidget()
        SeasonRankWidget()
    }
}
