//
//  SeasonRankView.swift
//  SeasonRankWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/1.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI

struct SeasonRankView: View {
    @Environment(\.widgetFamily) var family
    
    var entry: SeasonRankProvider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall: SeasonRankSmallView(entry: entry)
        case .systemLarge: SeasonRankLargeView(entry: entry)
        case .accessoryRectangular: SeasonRankRectangularView(entry: entry)
        case .accessoryInline: SeasonRankInlineView(entry: entry)
        case .accessoryCircular: SeasonRankCircularView(entry: entry)
        default: SeasonRankLargeView(entry: entry)
        }
    }
}
