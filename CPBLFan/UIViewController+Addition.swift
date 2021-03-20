//
//  UIViewController+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2021/3/20.
//  Copyright © 2021 Sparkr. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func throwToMainThreadAsync(_ closure: @escaping ()->Void) {
        DispatchQueue.main.async {
            closure()
        }
    }
}
