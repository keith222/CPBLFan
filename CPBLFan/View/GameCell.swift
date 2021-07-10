//
//  GameCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell, BindView{

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    private var streamUrl: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(_ viewModel: Any) {
        if let gameCellViewModel = viewModel as? GameCellViewModel{
            //cell content
            self.gameNumLabel.text = gameCellViewModel.num
            self.guestScoreLabel.text = gameCellViewModel.guestScore
            self.homeScoreLabel.text = gameCellViewModel.homeScore
            self.placeLabel.text = gameCellViewModel.place
            self.timeLabel.text = gameCellViewModel.timeString
            self.homeImageView.image = UIImage(named: gameCellViewModel.homeImageString)
            self.guestImageView.image = UIImage(named: gameCellViewModel.guestImageString)
            self.streamUrl = gameCellViewModel.streamUrl
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        containerView.backgroundColor = (highlighted) ? UIColor.CompromisedColors.systemGray5: UIColor.CompromisedColors.background
    }
}
