//
//  StatsListCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/11.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class StatsListCell: UITableViewCell,BindView {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindViewModel(_ viewModel: Any) {
        if let statsListCellViewModel = viewModel as? StatsListCellViewModel{
            self.numLabel.text = statsListCellViewModel.num
            self.nameLabel.text = statsListCellViewModel.name
            self.teamLabel.text = statsListCellViewModel.team
            self.statsLabel.text = statsListCellViewModel.stats
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.numLabel.textColor = highlighted ? .white : UIColor.CompromisedColors.label
        self.nameLabel.textColor = highlighted ? .white : UIColor.CompromisedColors.label
        self.teamLabel.textColor = highlighted ? .white : UIColor(hex: 0x9b9b9b)
        self.statsLabel.textColor = highlighted ? .white : UIColor.CompromisedColors.label
        self.backgroundColor = highlighted ? .darkBlue : UIColor.CompromisedColors.background
    }
    
}
