//
//  TeamGameWidget.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import WidgetKit
import SwiftUI
import SwifterSwift
import FirebaseCore
import AppIntents

struct TeamGameWidget: Widget {
    init() { FirebaseApp.configure() }
    
    let kind: String = "TeamGameWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: TeamGameIntent.self, provider: TeamGameProvider()) { entry in
            TeamGameView(entry: entry)
                .widgetBackground(Color("WidgetBlue"))
        }
        .configurationDisplayName("today_game".localized())
        .description("team_today_game_description")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}
