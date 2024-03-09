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
            self.rankLabel.text = rankCellViewModel.rank?.string ?? "1"
            self.teamLogoImageView.image = UIImage(named: rankCellViewModel.team?.logoLocalizedString ?? "")
            self.winLabel.text = rankCellViewModel.win?.string ?? "0"
            self.tieLabel.text = rankCellViewModel.tie?.string ?? "0"
            self.loseLabel.text = rankCellViewModel.lose?.string ?? "0"
            self.percentageLabel.text = rankCellViewModel.winningRate?.string ?? "0.0"
            self.gamebehindLabel.text = rankCellViewModel.gamebehind?.string ?? "0.0"
        }
    }
}
