//
//  RankCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/6.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class RankCell: UITableViewCell, BindView {
    
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var tieLabel: UILabel!
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var gamebehindLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = false
        // set team logo image
        self.teamLogoImageView.contentMode = .scaleAspectFill
    }

    func bindViewModel(_ viewModel: Any) {
        if let rankViewModel = viewModel as? RankViewModel{
            // cell content
            self.teamLogoImageView.image = UIImage.logoImage(team: rankViewModel.team)
            self.winLabel.text = rankViewModel.win
            self.tieLabel.text = rankViewModel.tie
            self.loseLabel.text = rankViewModel.lose
            self.percentageLabel.text = rankViewModel.percentage
            self.gamebehindLabel.text = rankViewModel.gamebehind
        }
    }
}
