//
//  GameCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/2.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell, BindView{

    
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var gameStatusLabel: UILabel!
    var streamUrl: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bindViewModel(_ viewModel: Any) {
        if let gameViewModel = viewModel as? GameViewModel{
            //cell content
            
            var numString = ""
            switch gameViewModel.game {
            case 0:
                numString = "All Stars Game"
            case _ where gameViewModel.game > 1:
                numString = "Game: \(gameViewModel.game!)"
            case _ where gameViewModel.game < 0:
                numString = "Taiwan Series: G\(-gameViewModel.game!)"
            default:
                break
            }
            
            self.gameNumLabel.text = numString
            self.guestScoreLabel.text = (gameViewModel.g_score.isEmpty) ? "--" : gameViewModel.g_score
            self.homeScoreLabel.text = (gameViewModel.h_score.isEmpty) ? "--" : gameViewModel.h_score
            self.placeLabel.text = gameViewModel.place
            self.homeImageView.image = UIImage(named: gameViewModel.home)
            self.guestImageView.image = UIImage(named: gameViewModel.guest)
            self.streamUrl = gameViewModel.stream
            self.gameStatusLabel.isHidden = !gameViewModel.stream.isEmpty
            self.streamButton.isHidden = gameViewModel.stream.isEmpty
        }
    }
    
    @IBAction func streamAction(_ sender: UIButton) {
        if let url = self.streamUrl{
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    
}
