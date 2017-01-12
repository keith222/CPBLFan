//
//  NewsTableViewCell.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/23.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import DynamicColor
import Kingfisher

class NewsCell: UITableViewCell, BindView {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }
    
    func setUp(){
        
        self.newsImage.contentMode = .scaleAspectFill
        self.newsImage.bounds = self.bounds
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.newsTitleLabel.font = UIFont.systemFont(ofSize: 30)
            self.newsDateLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func bindViewModel(_ viewModel: Any) {

        if let newsViewModel = viewModel as? NewsViewModel{
            //cell content
            self.newsImage.kf.setImage(with: newsViewModel.imageURL?.url!)
            self.newsTitleLabel.text = newsViewModel.title!
            self.newsDateLabel.text = newsViewModel.date!
        }
    }
}
