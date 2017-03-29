//
//  RankHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/8.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class RankHeaderCell: UITableViewHeaderFooterView, BindView {

    @IBOutlet weak var yearLabel: UILabel!
    
    func bindViewModel(_ viewModel: Any) {
        if let sectionString = viewModel as? String{
            self.yearLabel.text = sectionString
        }
    }
    
    override func awakeFromNib() {
        self.subviews[0].size.width = UIScreen.main.bounds.width
    }

}
