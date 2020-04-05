//
//  GameHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class GameHeaderCell: UITableViewHeaderFooterView, BindView {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Any) {
        if let data = viewModel as? GameHeaderCellViewModel{
            let week = Date(year: data.year, month: data.month, day: data.day)?.weekday ?? 0
            let chineseWeekDay = self.numberToChineseWeekDay(week)
            self.monthLabel.text = data.month?.string
            self.dayLabel.text = data.day?.string
            self.weekDayLabel.text = chineseWeekDay
        }
    }
    
    private func numberToChineseWeekDay(_ weekday: Int) -> String {
        switch weekday {
        case 1: return "星期日"
        case 2: return "星期一"
        case 3: return "星期二"
        case 4: return "星期三"
        case 5: return "星期四"
        case 6: return "星期五"
        case 7: return "星期六"
        default: return ""
        }
    }
    
    

}
