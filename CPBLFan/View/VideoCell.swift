//
//  VideoCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/28.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import Kingfisher
import SwifterSwift

class VideoCell: UITableViewCell, BindView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDateLabel: UILabel!
    @IBOutlet weak var videoContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.videoImageView.roundCorners([.topLeft, .topRight], radius: 20)
        self.videoContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        self.containerView.addShadow(ofColor: .black, radius: 10, offset: .zero, opacity: 0.4)
    }

    func setUp(){        
        // set fonsize if it is ipad
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.videoTitleLabel.font = UIFont.systemFont(ofSize: 30)
            self.videoDateLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func bindViewModel(_ viewModel: Any) {
        
        if let videoCellViewModel = viewModel as? VideoCellViewModel{
            // cell content
            
            let maxResDefault = videoCellViewModel.imageUrl?.replacingOccurrences(of: "hqdefault", with: "maxresdefault")
            self.videoImageView.kf.setImage(with: maxResDefault?.url)
            
            self.videoTitleLabel.text = videoCellViewModel.title
            
            // dateformat iso 8601 to normal dateformat
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let isoDateFormatter = ISO8601DateFormatter()
            let isoDate = isoDateFormatter.date(from: videoCellViewModel.date ?? "")
            let dateString = dateFormatter.string(from: isoDate!)
            self.videoDateLabel.text = dateString
        }
    }
    
}
