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
        if let sectionNum = viewModel as? Int{
            switch sectionNum {
            case 0:
                self.yearLabel.text = "上半季"
            case 1:
                self.yearLabel.text = "下半季"
            default:
                break
            }
        }
    }

}
