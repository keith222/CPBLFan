//
//  TodayGameMediumView.swift
//  TodayGameWidgetExtension
//
//  Created by Yang Tun-Kai on 2022/3/16.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit

struct TodayGameView : View {
    
    var entry: GameProvider.Entry
    
    var body: some View {
        VStack(alignment: .center, spacing: entry.games.count <= 3 ? 15 : 0) {
            Text("today_game".localized())
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
            
            if !entry.games.isEmpty {
                HStack(spacing: 5) {
                    ForEach(entry.games, id: \.game) { game in
                        GameView(with: game, and: entry.games.count)
                    }.frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: (entry.games.count > 2) ? .center : .leading)
                
            } else {
                Text("no_game_today".localized())
                    .font(.title2)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, maxHeight: 91)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.bottom, (entry.games.count > 2) ? 5 : 0)
        .widgetURL(URL(string: "CPBLFan://?game"))
    }
}

#Preview(as: .systemMedium) {
    TodayGameWidget()
} timeline: {
    GameEntry(date: Date(), games: [
        Game(game: 1, date: "2022-04-02", guest: "4", home: "3-0", place: "桃園國際棒球場", gScore: "", hScore: "", stream: "", time: "18:35"),
        Game(game: 2, date: "2022-04-02", guest: "-1", home: "2", place: "台南棒球場", gScore: "", hScore: "", stream: "", time: "18:35"),
        Game(game: 3, date: "2022-04-02", guest: "3-0", home: "2", place: "嘉義市棒球場", gScore: "", hScore: "", stream: "", time: "18:35"),
//        Game(game: 4, date: "2022-04-02", guest: "1", home: "4", place: "澄清湖棒球場", gScore: "", hScore: "", stream: "", time: "18:35"),
//        Game(game: 4, date: "2022-04-02", guest: "1", home: "4", place: "澄清湖棒球場", gScore: "", hScore: "", stream: "", time: "18:35"),
//        Game(game: 4, date: "2022-04-02", guest: "1", home: "4", place: "澄清湖棒球場", gScore: "", hScore: "", stream: "", time: "18:35")
    ])
}
