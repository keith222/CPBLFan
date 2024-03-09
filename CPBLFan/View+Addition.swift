//
//  View+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2024/3/3.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import Foundation
import SwiftUI
import WidgetKit

@available(iOS 13.0, *)
extension View {
    
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
