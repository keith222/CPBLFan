//
//  SeasonRankCircularView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/4.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct SeasonRankCircularView: View {
    
    var entry: SeasonRankProvider.Entry
    
    var totalGames: Int {
        switch entry.title {
        case "1st".localized(), "2nd".localized(): return 60
        default: return 120
        }
    }
    
    var body: some View {
        Gauge(
            value: Double(entry.ranks.first?.win ?? 0),
            in: 0...totalGames.double,
            label: { Text("Standing") },
            currentValueLabel: {
                VStack(spacing: 0) {
                    Text("🥇")
                        .font(.system(size: 9))
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    
                    if let team = entry.ranks.first?.team.logoLocalizedString {
                        Image(team)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background(
                                Color.white
                                    .opacity(0.8)
                                    .cornerRadius(3)
                            )
                        
                    } else {
                        Color.white
                            .opacity(0.8)
                            .frame(width: 20, height: 20)
                            .cornerRadius(3)
                    }
                }
                .padding(.bottom, 8)
            },
            minimumValueLabel: {
                Text("\(entry.ranks.first?.win ?? 0)W")
                    .fontWeight(.semibold)
                    .font(.system(size: 7))
            },
            maximumValueLabel: {
                Text("\(entry.ranks.first?.lose ?? 0)L")
                    .fontWeight(.semibold)
                    .font(.system(size: 7))
            })
        .gaugeStyle(.accessoryCircular)
        
    }
}

#Preview(as: .accessoryCircular) {
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
