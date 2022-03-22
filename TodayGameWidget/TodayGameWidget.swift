//
//  TodayGameWidget.swift
//  TodayGameWidget
//
//  Created by Yang Tun-Kai on 2022/3/13.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import WidgetKit
import SwiftUI
import SwifterSwift
import Firebase

@main
struct TodayGameWidget: Widget {
    init() { FirebaseApp.configure() }
    
    let kind: String = "TodayGameWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodayGameMediumView(entry: entry)
        }
        .configurationDisplayName("today_game".localized())
        .description("today_game_description")
        .supportedFamilies([.systemMedium])
    }
}


