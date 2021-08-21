//
//  NewsTableViewCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/23.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import Kingfisher

class NewsCell: UITableViewCell, BindView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsContainerView: UIView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.newsImage.roundCorners([.topLeft, .topRight], radius: 20)
        self.newsContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        self.containerView.addShadow(ofColor: .black, radius: 10, offset: .zero, opacity: 0.4)
    }
    
    func setUp(){
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.newsTitleLabel.font = UIFont.systemFont(ofSize: 30)
            self.newsDateLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func bindViewModel(_ viewModel: Any) {

        if let newsCellViewModel = viewModel as? NewsCellViewModel{
            //cell content
            if let url = newsCellViewModel.imageURL?.removingPercentEncoding?.url {
                self.newsImage.kf.setImage(with: url, options: [.onFailureImage(UIImage(named: "logo")),.transition(.fade(0.1))])
            }else{
                self.newsImage.image = UIImage(named: "logo")
            }
            self.newsTitleLabel.text = newsCellViewModel.title!
            self.newsDateLabel.text = newsCellViewModel.date!
        }
    }
}
