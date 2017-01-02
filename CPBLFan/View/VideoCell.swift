//
//  VideoCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/28.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import DynamicColor
import Kingfisher
import SwifterSwift

class VideoCell: UITableViewCell, BindView {

    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDateLabel: UILabel!
    var videoId: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }

    func setUp(){
        self.videoImageView.contentMode = .scaleAspectFill
        self.videoImageView.bounds = self.bounds
        self.videoImageView.clipsToBounds = true
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.videoTitleLabel.font = UIFont.systemFont(ofSize: 30)
            self.videoDateLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func bindViewModel(_ viewModel: Any) {
        
        if let videoViewModel = viewModel as? VideoViewModel{
            //cell content
            self.videoImageView.kf.setImage(with: URL(string: videoViewModel.imageUrl!))
            
            self.videoTitleLabel.text = videoViewModel.title!
            
            //dateformat iso 8601 to normal dateformat
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY.MM.DD"
            let isoDate = Date(iso8601String: videoViewModel.date!)
            let dateString = dateFormatter.string(from: isoDate!)
            self.videoDateLabel.text = dateString
            
            self.videoId = videoViewModel.videoId!
        }
    }
    
}
