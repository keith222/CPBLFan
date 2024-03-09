//
//  SeasonRankRectangularView.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2024/3/3.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct SeasonRankRectangularView: View {
    
    var entry: SeasonRankProvider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("cpbl_title")
                
                Spacer()
                
                Text(entry.title.localized())
            }
            .foregroundStyle(.white)
            .fontWeight(.semibold)
            
            HStack {
                Text("🥇")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if let team = entry.ranks.first?.team.logoLocalizedString {
                    Image(team)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(
                            Color.white
                                .opacity(0.8)
                                .cornerRadius(5)
                        )
                }
            }
        }
        .padding()
        .containerBackground(for: .widget) {}
    }
}

#Preview(as: .accessoryRectangular) {
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
