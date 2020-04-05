//
//  UITableView+Addition.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/3/7.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
