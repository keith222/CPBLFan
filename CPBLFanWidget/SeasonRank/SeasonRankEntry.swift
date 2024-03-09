//
//  SeasonRankEntry.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/1.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import WidgetKit
import Foundation

struct SeasonRankEntry: TimelineEntry {
    let date: Date
    let title: String
    let ranks: [Rank]
}

