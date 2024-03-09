//
//  SeasonRankInlineView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/3.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct SeasonRankInlineView: View {
    
    var entry: SeasonRankProvider.Entry
    
    var body: some View {
        Text("\("cpbl_title".localized()) \(entry.title.localized()) 🥇\(entry.ranks.first?.team.getShortTeamByNo() ?? "--")")
    }
}

#Preview(as: .accessoryInline) {
    SeasonRankWidget()
} timeline: {
    let first = [
        Rank(team: "-1", rank: 1, win: 1, lose: 1, tie: 1, displayRank: 1, winningRate: 0, gameBehind: 0),
        Rank(team: "1", rank: 2, win: 1, lose: 1, tie: 1, displayRank: 2, winningRate: 0, gameBehind: 0),
        Rank(team: "2", rank: 3, win: 1, lose: 1, tie: 1, displayRank: 3, winningRate: 0, gameBehind: 0)
    ]
    let second = [
        Rank(team: "-1", rank: 1, win: 0, lose: 0, tie: 0, displayRank: 1, winningRate: 0, gameBehind: 0),
        Rank(team: "1", rank: 2, win: 0, lose: 0, tie: 0, displayRank: 2, winningRate: 0, gameBehind: 0),
        Rank(team: "2", rank: 3, win: 0, lose: 0, tie: 0, displayRank: 3, winningRate: 0, gameBehind: 0)
    ]
    SeasonRankEntry(date: .now, title: "1st".localized(), ranks: first)
    SeasonRankEntry(date: .now, title: "2nd".localized(), ranks: second)
    SeasonRankEntry(date: .now, title: "full".localized(), ranks: [])
}
