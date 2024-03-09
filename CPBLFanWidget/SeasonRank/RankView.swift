//
//  RankView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/2.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RankView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        return colorScheme == .dark
    }
    
    var rank: Rank
    
    var body: some View {
        HStack(spacing: 15) {
            Text(rank.displayRank.string)
                .frame(width: 15)
            
            if !rank.team.logoLocalizedString.isEmpty {
                Image(rank.team.logoLocalizedString)
                    .resizable()
                    .padding(1)
                    .frame(width: 35, height: 35)
                    .padding(.horizontal, 5)
                
            } else {
                generateDefaultView(size: 35)
                
            }
            
            Text(rank.win.string)
                .frame(width: 25)
            
            Text(rank.tie.string)
                .frame(width: 25)
            
            Text(rank.lose.string)
                .frame(width: 25)
            
            Text(rank.winningRate.string)
                .frame(width: 40)
            
            Text(rank.gameBehind.string)
                .frame(width: 30)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func generateDefaultView(size: CGFloat, cornerRadius: CGFloat = 10) -> some View {
        if isDarkMode {
            Color.white
                .opacity(0.2)
                .cornerRadius(cornerRadius)
                .frame(width: size, height: size)
                .padding(.horizontal, 5)
                
                
        } else {
            Color.black
                .opacity(0.2)
                .cornerRadius(cornerRadius)
                .frame(width: size, height: size)
                .padding(.horizontal, 5)
        }
    }
}

#Preview(as: .systemLarge) {
    SeasonRankWidget()
} timeline: {
    let first = [
        Rank(team: "-1", rank: 1, win: 1, lose: 1, tie: 1, displayRank: 1, winningRate: 0, gameBehind: 0),
        Rank(team: "1", rank: 2, win: 1, lose: 1, tie: 1, displayRank: 2, winningRate: 0, gameBehind: 0),
        Rank(team: "2", rank: 3, win: 1, lose: 1, tie: 1, displayRank: 3, winningRate: 0, gameBehind: 0),
        Rank(team: "3-0", rank: 4, win: 1, lose: 1, tie: 1, displayRank: 4, winningRate: 0, gameBehind: 0),
        Rank(team: "4", rank: 5, win: 1, lose: 1, tie: 1, displayRank: 5, winningRate: 0, gameBehind: 0),
        Rank(team: "6", rank: 6, win: 1, lose: 1, tie: 1, displayRank: 6, winningRate: 0, gameBehind: 0)
    ]
    let second = [
        Rank(team: "-1", rank: 1, win: 1, lose: 1, tie: 1, displayRank: 1, winningRate: 0, gameBehind: 0),
        Rank(team: "1", rank: 2, win: 1, lose: 1, tie: 1, displayRank: 2, winningRate: 0, gameBehind: 0),
        Rank(team: "2", rank: 3, win: 1, lose: 1, tie: 1, displayRank: 3, winningRate: 0, gameBehind: 0),
        Rank(team: "3-0", rank: 4, win: 1, lose: 1, tie: 1, displayRank: 4, winningRate: 0, gameBehind: 0),
        Rank(team: "4", rank: 5, win: 1, lose: 1, tie: 1, displayRank: 5, winningRate: 0, gameBehind: 0),
        Rank(team: "6", rank: 6, win: 1, lose: 1, tie: 1, displayRank: 6, winningRate: 0, gameBehind: 0)
    ]
    SeasonRankEntry(date: .now, title: "1st".localized(), ranks: first)
    SeasonRankEntry(date: .now, title: "2nd".localized(), ranks: second)
    SeasonRankEntry(date: .now, title: "full".localized(), ranks: [])
}
