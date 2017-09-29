//
//  GameHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift

class GameHeaderCell: UITableViewHeaderFooterView, BindView {

    @IBOutlet weak var dateLabel: UILabel!
    
    func bindViewModel(_ viewModel: Any) {
        if let data = viewModel as? [String]{
            let week = Date(year: data[0].int, month: data[1].int, day: data[2].int)?.weekday
            let chineseWeekDay = self.numberToChineseWeekDay(week!)
            self.dateLabel.text = "\(data[1])月\(data[2])日 \(chineseWeekDay)"
        }
    }
    
    private func numberToChineseWeekDay(_ weekday: Int) -> String {
        switch weekday {
        case 1: return "週日"
        case 2: return "週一"
        case 3: return "週二"
        case 4: return "週三"
        case 5: return "週四"
        case 6: return "週五"
        case 7: return "週六"
        default: return ""
        }
    }
    
    override func awakeFromNib() {
        // for ios9 below
        self.subviews[0].size.width = UIScreen.main.bounds.width
    }

}
