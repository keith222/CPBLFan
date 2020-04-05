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
    }

    func bindViewModel(_ viewModel: Any) {
        if let gameCellViewModel = viewModel as? GameCellViewModel{
            //cell content
            self.gameNumLabel.text = gameCellViewModel.num
            self.placeLabel.text = gameCellViewModel.place
            self.homeImageView.image = UIImage(named: gameCellViewModel.homeImageString)
            self.guestImageView.image = UIImage(named: gameCellViewModel.guestImageString)
        }
    }
}
