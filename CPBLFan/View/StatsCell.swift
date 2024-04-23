//
//  StatsCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/9.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell, BindView {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.categoryLabel.layer.cornerRadius = self.categoryLabel.bounds.height / 2
        self.categoryLabel.layer.masksToBounds = true
    }

    func bindViewModel(_ viewModel: Any) {
        if let statsCellViewModel = viewModel as? StatsCellViewModel{
            self.nameLabel.text = statsCellViewModel.name
            self.teamLabel.text = statsCellViewModel.team?.getTeam()
            self.statsLabel.text = statsCellViewModel.stats
            self.categoryLabel.text = statsCellViewModel.category
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.categoryLabel.textColor = highlighted ? .darkBlue : .white
        self.categoryLabel.backgroundColor = highlighted ? .white : .darkBlue
        self.nameLabel.textColor = highlighted ? .white : UIColor.CompromisedColors.label
        self.teamLabel.textColor = highlighted ? .white : UIColor(hex: 0x9b9b9b)
        self.statsLabel.textColor = highlighted ? .white : UIColor.CompromisedColors.label
        self.backgroundColor = highlighted ? .darkBlue : UIColor.CompromisedColors.background
    }
}
