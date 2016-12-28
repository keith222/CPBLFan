//
//  VideoCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/28.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDateLabel: UILabel!
    @IBOutlet weak var videoDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
