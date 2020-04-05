//
//  UIColor+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/9.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

extension UIColor{
    
    static let darkBlue: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return the color for Dark Mode
                    return UIColor(hex: 0x0e90c4) ?? .clear
                    
                } else {
                    // Return the color for Light Mode
                    return UIColor(hex: 0x081b2f) ?? .clear
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.
            return UIColor(hex: 0x081b2f) ?? .clear
        }
    }()
    
    
    
    
    enum CompromisedColors {
        static let label: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.label
            } else {
                return .black
            }
        }()
        
        static let background: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                return .white
            }
        }()
        
        static let secondarySystemBackground: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.secondarySystemBackground
            } else {
                return .white
            }
        }()
        
        static let tertiarySystemBackground: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.tertiarySystemBackground
            } else {
                return .white
            }
        }()
        
        static let systemGray: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.systemGray
            } else {
                return .gray
            }
        }()
        
        
        static let separator: UIColor = {
            if #available(iOS 13.0, *) {
                return UIColor.separator
            } else {
                return .white
            }
        }()
    }
}
