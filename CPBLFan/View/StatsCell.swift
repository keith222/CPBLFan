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
        
        self.categoryLabel.cornerRadius = self.categoryLabel.bounds.height / 2
        //self.categoryLabel.adjustsFontSizeToFitWidth = true
    }

    func bindViewModel(_ viewModel: Any) {
        if let viewModelArray = viewModel as? [StatsViewModel]{
            self.nameLabel.text = viewModelArray[0].name
            self.teamLabel.text = viewModelArray[0].team
            self.statsLabel.text = viewModelArray[0].stats
            self.categoryLabel.text = viewModelArray[0].category
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.categoryLabel.textColor = UIColor.darkBlue()
            self.categoryLabel.backgroundColor = .white
            self.nameLabel.textColor = .white
            self.teamLabel.textColor = .white
            self.statsLabel.textColor = .white
            self.backgroundColor = UIColor.darkBlue()
        }else{
            self.categoryLabel.textColor = .white
            self.categoryLabel.backgroundColor = UIColor.darkBlue()
            self.nameLabel.textColor = .black
            self.teamLabel.textColor = UIColor(hexString: "#9b9b9b")
            self.statsLabel.textColor = .black
            self.backgroundColor = .white
        }
    }
    
}
