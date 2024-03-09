//
//  TeamGameIntent.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import Foundation
import WidgetKit
import AppIntents
import SwifterSwift

struct TeamGameIntent: WidgetConfigurationIntent {
    
    static var title: LocalizedStringResource = "Select Team"
    static var description: IntentDescription = IntentDescription("Select a Team")
    
    @Parameter(title: "Team")
    var team: TeamEntity
}
