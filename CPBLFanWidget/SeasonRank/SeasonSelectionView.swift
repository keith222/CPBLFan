//
//  SeasonSelectionView.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/5.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI

struct SeasonSelectionView: View {
    
    @AppStorage("selectedSeason") private var selectedSeason: Int = 2
    
    var backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                Button(intent: TabButtonIntent(seasonNumber: index)) {
                    Text(getButtonTitle(of: index))
                        .font(.caption)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                        .padding(.vertical, 5)
                        .background(index == selectedSeason ? backgroundColor : Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
    
    private func getButtonTitle(of index: Int) -> String {
        switch index {
        case 0: return "1st".localized()
        case 1: return "2nd".localized()
        case 2: return "full".localized()
        default: return ""
        }
    }
}
