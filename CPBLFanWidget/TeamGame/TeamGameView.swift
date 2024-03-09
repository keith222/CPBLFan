//
//  TeamGameView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct TeamGameView: View {
    
    private var place: String {
        guard let place = entry.game?.place else { return "--" }
        
        return "@\(((place) + "_short").localized())"
    }
    
    private var time: String {
        guard let time = entry.game?.time else { return "--" }
        
        return "\(time) (GMT+8)"
    }
    
    var entry: TeamGameProvider.Entry
        
    var body: some View {
        VStack(spacing: 5) {
            Text("today_game")
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 5)
                .padding(.leading, 5)
            
            HStack {
                Text(place)
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .fontWeight(.semibold)
                
                Text(time)
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
            
            if !entry.entity.id.isEmpty {
                HStack(spacing: 0) {
                    Image(entry.entity.id.logoLocalizedString)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 65, height: 70)
                    
                    Text("VS")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .frame(width: 20)
                    
                    if let game = entry.game, let guest = game.guest {
                        Image(guest.logoLocalizedString)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 65, height: 70)
                        
                    } else {
                        Text("No Game Today")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                            .frame(width: 65, height: 70)
                            .foregroundColor(.white)
                    }
                }

            } else {
                Text("no_team")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(width: 150, height: 70, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
            }
            
        }
        .padding(.horizontal)
        .widgetURL(URL(string: "CPBLFan://?game"))
    }
}

#Preview(as: .systemSmall) {
    TeamGameWidget()
} timeline: {
    TeamGameEntry(date: .now, entity: TeamEntity(id: "-1"), game: Game(game: 360, date: "2024-09-28", guest: "6", home: "-1", place: "台北大巨蛋", gScore: "", hScore: nil, stream: nil, time: "18:30"))
    
    TeamGameEntry(date: .now, entity: TeamEntity(id: "-1"), game: nil)
    
    TeamGameEntry(date: .now, entity: TeamEntity(id: ""), game: nil)
}
