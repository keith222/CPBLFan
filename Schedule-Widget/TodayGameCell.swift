//
//  TodayGameCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/26.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class TodayGameCell: UITableViewCell, BindView {

    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // for ios9
        if #available(iOS 10, *) {}else{
            for views in self.subviews[0].subviews as [UIView]{
                if let label = views as? UILabel{
                    label.textColor = .white
                }
            }
        }
    }

    func bindViewModel(_ viewModel: Any) {
        if let gameViewModel = viewModel as? GameViewModel{
            //cell content
            
            var numString = ""
            switch gameViewModel.game {
            case 0:
                numString = "All Stars Game"
            case _ where gameViewModel.game > 0:
                numString = "Game: \(gameViewModel.game!)"
            case _ where gameViewModel.game < 0:
                numString = "Taiwan Series: G\(-gameViewModel.game!)"
            default:
                break
            }
            
            self.gameNumLabel.text = numString
            self.guestImageView.image = UIImage(named: gameViewModel.guest)
            self.homeImageView.image = UIImage(named: gameViewModel.home)
            self.placeLabel.text = gameViewModel.place
        }
    }
    
}
