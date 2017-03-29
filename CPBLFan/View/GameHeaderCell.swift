//
//  GameHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class GameHeaderCell: UITableViewHeaderFooterView, BindView {

    @IBOutlet weak var dateLabel: UILabel!
    
    func bindViewModel(_ viewModel: Any) {
        if let data = viewModel as? [String]{
            self.dateLabel.text = "\(data[0])月\(data[1])日"
        }
    }
    
    override func awakeFromNib() {
        // for ios9 below
        self.subviews[0].size.width = UIScreen.main.bounds.width
    }

}
