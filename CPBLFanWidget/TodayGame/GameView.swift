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
        if (count <= 4) {
            let imageSize = (count <= 3) ? 35.0 : 25.0
            
            VStack(spacing: 3) {
                HStack(alignment: .center, spacing: 0) {
                    Image(game.guest?.logoLocalizedString ?? "")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                    
                    Text("VS")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                        .frame(width: 15)
                    
                    Image(game.home?.logoLocalizedString ?? "")
                        .resizable()
                        .frame(width: imageSize, height: imageSize)
                }
                
                Text("Game \(game.game ?? 0)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                
                Text("@\(((game.place ?? "") + "_short").localized())")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                
                Text("\(game.time ?? "") (GMT+8)")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(5)
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius:10))
        } else {
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
                    .font(.system(size: 8))
                
            }
            .frame(maxWidth: .infinity)
            .padding(5)
            .background(.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius:10))
        }
    }
}
