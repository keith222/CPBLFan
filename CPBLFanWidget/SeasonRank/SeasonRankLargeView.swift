//
//  SeasonRankLargeView.swift
//  SeasonRankWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/1.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct SeasonRankLargeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedSeason") private var selectedSeason: Int = 2
    
    private var isDarkMode: Bool {
        return colorScheme == .dark
    }
    private var buttonSelectedColor: Color {
        return isDarkMode ? .lightBlue : .darkBlue
    }
    private var backgroundColor: Color {
        return isDarkMode ?  Color.white.opacity(0.2) :  Color.black.opacity(0.2)
    }
    
    var entry: SeasonRankProvider.Entry
    
    var title: String {
        switch entry.title {
        case "1st".localized(): return "上半季"
        case "2nd".localized(): return "下半季"
        case "full".localized(): return "全年度"
        default: return "--"
        }
    }
    
    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text("cpbl_title")
                
                Spacer()
                
                Text("season_rank")
            }
            .font(.title3)
            .padding(.horizontal)
            
            SeasonSelectionView(backgroundColor: backgroundColor)
            
            RankHeaderView(backgroundColor: backgroundColor)
            
            if !entry.ranks.isEmpty {
                ForEach(entry.ranks, id: \.team) { rank in
                    RankView(rank: rank)
                }
            } else {
                Spacer()
            }
        }
        .foregroundStyle(.white)
        .fontWeight(.semibold)
        .padding(.vertical, 5.5)
        .widgetURL(URL(string: "CPBLFan://?rank"))    
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
