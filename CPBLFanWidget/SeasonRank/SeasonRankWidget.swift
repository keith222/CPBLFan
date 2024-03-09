//
//  SeasonRankWidget.swift
//  SeasonRankWidget
//
//  Created by Yang Tun-Kai on 2024/2/28.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import WidgetKit
import SwiftUI
import FirebaseCore


struct SeasonRankWidget: Widget {
    @Environment(\.colorScheme) var colorScheme
        
    let kind: String = "SeasonRankWidget"

    init() { FirebaseApp.configure() }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SeasonRankProvider()) { entry in
            SeasonRankView(entry: entry)
                .widgetBackground(Color("WidgetBlue"))
        }
        .configurationDisplayName("season_rank".localized())
        .description("season_rank_description")
        .supportedFamilies([.systemSmall, .systemLarge, .accessoryRectangular, .accessoryInline, .accessoryCircular])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    SeasonRankWidget()
} timeline: {
    SeasonRankEntry(date: .now, title: "1st".localized(), ranks: [])
}
