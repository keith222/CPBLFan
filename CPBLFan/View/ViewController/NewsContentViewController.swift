//
//  NewsContentViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2016/12/24.
//  Copyright © 2016年 Sparkr. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD

class NewsContentViewController: UIViewController {

    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsContentLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    var newsContentViewModel: NewsContentViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func bindViewModel() {
        // get news content
        self.newsContentViewModel?.loadNewsContent = { [weak self] content in
            let attributedString = NSMutableAttributedString(string: content)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            self?.newsContentLabel.attributedText = attributedString
        }
        
        if let imageUrl = self.newsContentViewModel?.imageUrl.url {
             self.newsImage.kf.setImage(with: imageUrl)
        } else {
            self.newsImage.image = UIImage(named: "logo")
        }
        
        self.newsTitleLabel.text = self.newsContentViewModel?.title
        self.newsDateLabel.text = self.newsContentViewModel?.date
        self.linkLabel.text = self.newsContentViewModel?.route
    }

    @IBAction func dissmissAction(_ sender: UIButton) {
        self.buttonStackView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeFontSizeAction(_ sender: UIButton) {
        let size = self.newsContentLabel.font.pointSize
        if !(self.newsContentViewModel?.fontChanged ?? false){
            self.newsContentLabel.font = UIFont.systemFont(ofSize: size * 2)
        }else{
            self.newsContentLabel.font = UIFont.systemFont(ofSize: size / 2)
        }
        self.newsContentViewModel?.fontChanged = !(self.newsContentViewModel?.fontChanged ?? false)
    }
 
    @IBAction func shareNewsAction(_ sender: UIButton) {
        if let newsUrl = self.newsContentViewModel?.route.url {
            let activity: UIActivityViewController = UIActivityViewController(activityItems: [newsUrl], applicationActivities: nil)
            self.present(activity, animated: true, completion: nil)
        }
    }

    @objc func openLink(recognizer: UITapGestureRecognizer) {
        if let linkLabel = recognizer.view as? UILabel, let url = linkLabel.text {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}
