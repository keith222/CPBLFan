//
//  WidgetCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/25.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class WidgetCell: UITableViewCell, BindView{
    
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
        
        if #available(iOS 10, *) {}else{
            for views in self.subviews[0].subviews as [UIView]{
                if let label = views as? UILabel{
                    label.textColor = .white
                }
            }
        }
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
