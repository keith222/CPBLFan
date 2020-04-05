//
//  WidgetHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/25.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class WidgetHeaderCell: UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = UIColor.darkBlue
        contentView.subviews.forEach({ view in
            if let label = view as? UILabel {
                label.textColor = .white
            }
        })
    }
}
