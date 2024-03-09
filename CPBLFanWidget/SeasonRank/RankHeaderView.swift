//
//  RankHeaderView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/5.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import SwifterSwift

struct RankHeaderView: View {
    
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Text("#")
                .frame(width: 15)
            
            Text("team")
                .frame(width: 45)
            
            Text("w")
                .frame(width: 25)
            
            Text("t")
                .frame(width: 25)
            
            Text("l")
                .frame(width: 25)
            
            Text("pct")
                .frame(width: 40)
            
            Text("GB")
                .frame(width: 30)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
    }
}
