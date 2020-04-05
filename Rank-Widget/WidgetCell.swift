//
//  WidgetCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/25.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class WidgetCell: UITableViewCell, BindView{
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var tieLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var gamebehindLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.isUserInteractionEnabled = false
        // set team logo image
        self.teamLogoImageView.contentMode = .scaleAspectFill
    }

    func bindViewModel(_ viewModel: Any) {
        if let rankCellViewModel = viewModel as? RankCellViewModel{
            // cell content
            self.rankLabel.text = "\(rankCellViewModel.rank ?? 0)"
            self.teamLogoImageView.image = UIImage.logoImage(team: rankCellViewModel.team)
            self.winLabel.text = rankCellViewModel.win
            self.tieLabel.text = rankCellViewModel.tie
            self.loseLabel.text = rankCellViewModel.lose
            self.percentageLabel.text = rankCellViewModel.percentage
            self.gamebehindLabel.text = rankCellViewModel.gamebehind
        }
    }
}
