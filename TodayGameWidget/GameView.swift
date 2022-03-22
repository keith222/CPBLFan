//
//  GameView.swift
//  TodayGameWidgetExtension
//
//  Created by Yang Tun-Kai on 2022/3/16.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct GameView : View {
    
    private let game: Game
    private let count: Int
    
    init(with game: Game, and count: Int) {
        self.game = game
        self.count = count
    }
    
    var body: some View {
        HStack(spacing: 0){
            VStack(alignment: .center, spacing: 0) {
                Image(game.guest?.logoLocalizedString ?? "")
                    .resizable()
                    .frame(width: 35, height: 35)
                
                Text("VS")
                    .foregroundColor(.white)
                    .font(.system(size: 9))
                    .fontWeight(.bold)
                    .frame(width: 15)
                
                Image(game.home?.logoLocalizedString ?? "")
                    .resizable()
                    .frame(width: 35, height: 35)
                
                if (count >= 5) {
                    Text("G \(game.game ?? 0)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    
                    Text("\(game.time ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    
                    Text("(GMT+8)")
                        .foregroundColor(.white)
                        .font(.system(size: 9))
                    
                }
            }
            
            if count < 5 {
                VStack(alignment: .center, spacing: 5) {
                    Text("G \(game.game ?? 0)")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    
                    Text("\(((game.place ?? "") + "_short").localized())")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    
                    Text("\(game.time ?? "")")
                        .foregroundColor(.white)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    
                    Text("(GMT+8)")
                        .foregroundColor(.white)
                        .font(.system(size: 8))
                
                }
            }
        }
        .padding(5)
        .background(.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius:10))
    }
}
