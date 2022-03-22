//
//  Color+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2022/3/13.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    static let darkBlue = Color(hex: 0x081b2f)
    static let lightBlue = Color(hex: 0x0e90c4)
}
