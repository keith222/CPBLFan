//
//  TeamGameEntry.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import Foundation
import WidgetKit

struct TeamGameEntry: TimelineEntry {
    let date: Date
    let entity: TeamEntity
    let game: Game?
}
