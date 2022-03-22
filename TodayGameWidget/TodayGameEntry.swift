//
//  TodayGameEntry.swift
//  TodayGameWidgetExtension
//
//  Created by Yang Tun-Kai on 2022/3/16.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import WidgetKit
import Foundation
import CoreGraphics

struct GameEntry: TimelineEntry {
    let date: Date
    let games: [Game]
}
