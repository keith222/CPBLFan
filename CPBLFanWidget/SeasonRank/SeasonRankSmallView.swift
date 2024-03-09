//
//  SeasonRankSmallView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/2.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct SeasonRankSmallView: View {
    @Environment(\.colorScheme) var colorScheme
    
    private var isDarkMode: Bool {
        return colorScheme == .dark
    }
    
    private var backgroundColor: Color {
        return isDarkMode ? Color.darkBlue : Color.lightBlue
    }
   
    var entry: SeasonRankProvider.Entry
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            HStack {
                Text("CPBL")
                    .foregroundStyle(.white)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(entry.title.localized())
            }
            .foregroundStyle(.white)
            .font(.subheadline)
            .fontWeight(.semibold)
            
            HStack {
                Text("🥇")
                    .foregroundStyle(.white)
                    .font(.system(size: 45))
                
                if !entry.ranks.isEmpty {
                    Image(entry.ranks[0].team.logoLocalizedString)
                        .resizable()
                        .cornerRadius(10)
                        .frame(width: 90, height: 90)
                        .background(.clear)
                } else {
                    generateDefaultView(size: 90)
                }
            }
            
            HStack {
                Spacer()
                
                Group {
                    Text("🥈")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    if !entry.ranks.isEmpty {
                        Image(entry.ranks[1].team.logoLocalizedString)
                            .resizable()
                            .cornerRadius(5)
                            .frame(width: 30, height: 30)

                    } else {
                        generateDefaultView(size: 30, cornerRadius: 5)
                    }
                }
                        
                Group {
                    Text("🥉")
                        .foregroundStyle(.white)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                    
                    if !entry.ranks.isEmpty {
                        Image(entry.ranks[2].team.logoLocalizedString)
                            .resizable()
                            .cornerRadius(5)
                            .frame(width: 30, height: 30)
                        
                    } else {
                        generateDefaultView(size: 30, cornerRadius: 5)
                    }
                }
            }
           
        }
        .padding(10)
        .widgetURL(URL(string: "CPBLFan://?rank"))
    }
    
    @ViewBuilder
    private func generateDefaultView(size: CGFloat, cornerRadius: CGFloat = 10) -> some View {
        if isDarkMode {
            Color.white
                .opacity(0.2)
                .cornerRadius(cornerRadius)
                .padding(5)
                .frame(width: size, height: size)
                
                
        } else {
            Color.black
                .opacity(0.2)
                .cornerRadius(cornerRadius)
                .padding(5)
                .frame(width: size, height: size)                                
        }
    }
}

#Preview(as: .systemSmall) {
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
