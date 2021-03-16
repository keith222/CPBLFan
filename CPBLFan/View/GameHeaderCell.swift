//
//  GameHeaderCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class GameHeaderCell: UITableViewHeaderFooterView, BindView {
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Any) {
        if let data = viewModel as? GameHeaderCellViewModel{
            if let date = Date(year: data.year, month: data.month, day: data.day) {
                let daySymbol = (Locale.preferredLanguages.first?.lowercased() ?? "").contains("zh-hant") ? "日" : ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM d\(daySymbol)"
                self.dateLabel.text = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "EEEE"
                self.weekDayLabel.text = dateFormatter.string(from: date)
            }
        }
    }
}
