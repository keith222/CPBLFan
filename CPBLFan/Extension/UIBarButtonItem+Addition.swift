//
//  UIBarButtonItem+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/4.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    class func noTitleBarButtonItem() -> UIBarButtonItem{
        return UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
