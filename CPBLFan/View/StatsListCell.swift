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
        if let statsListViewModel = viewModel as? StatsListViewModel{
            self.numLabel.text = statsListViewModel.num
            self.nameLabel.text = statsListViewModel.name
            self.teamLabel.text = statsListViewModel.team
            self.statsLabel.text = statsListViewModel.stats
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted{
            self.numLabel.textColor = .white
            self.nameLabel.textColor = .white
            self.teamLabel.textColor = .white
            self.statsLabel.textColor = .white
            self.backgroundColor = UIColor.darkBlue()
        }else{
            self.numLabel.textColor = .black
            self.nameLabel.textColor = .black
            self.teamLabel.textColor = UIColor(hexString: "#9b9b9b")
            self.statsLabel.textColor = .black
            self.backgroundColor = .white
        }
    }
    
}
