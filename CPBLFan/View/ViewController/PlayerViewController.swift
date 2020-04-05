//
//  PlayerViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/14.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import Alamofire
import Kanna
import PKHUD
import WebKit

enum PlayerType: String {
    case batter = "打擊成績"
    case pitcher = "投球成績"
}

class PlayerViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    @IBOutlet weak var statsWebView: WKWebView!
    @IBOutlet weak var fieldingWebView: WKWebView!
    @IBOutlet weak var teamStatsWebView: WKWebView!
    @IBOutlet weak var singleGameWebView: WKWebView!
    
    @IBOutlet weak var statsWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fieldingWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teamStatsWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var singleGameWebViewHeight: NSLayoutConstraint!

    var playerViewModel: PlayerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setUp()
        self.bindViewModel()
    }
        
    private func bindViewModel() {
        self.playerViewModel?.loadImageHtmlClosure = { [weak self] (head, game) in
            self?.headImageView.kf.setImage(with: head?.url)
            
            do{
                let imageData = try Data(contentsOf: (game?.url)!)
                self?.gameImageView.image = UIImage(data: imageData)
            }catch{
                self?.gameImageView.image = UIImage(named: "logo")
            }
        }
        
        self.playerViewModel?.loadHtmlStringClosure = { [weak self] (statsContent, fieldContent, teamContent, singleContent, playerInfo, infoString) in
            self?.statsWebView.loadHTMLString(statsContent.html, baseURL: nil)
            self?.statsWebViewHeight.constant = statsContent.height

            self?.fieldingWebView.loadHTMLString(fieldContent.html, baseURL: nil)
            self?.fieldingWebViewHeight.constant = fieldContent.height
            
            self?.teamStatsWebView.loadHTMLString(teamContent.html, baseURL: nil)
            self?.teamStatsWebViewHeight.constant = teamContent.height
            
            self?.singleGameWebView.loadHTMLString(singleContent.html, baseURL: nil)
            self?.singleGameWebViewHeight.constant = singleContent.height
            
            self?.nameLabel.text = playerInfo
            self?.dataLabel.text = infoString
        }
        
        self.playerViewModel?.errorHandleClosure = {
            HUD.hide(animated: true)
        }
        
        self.statsLabel.text = self.playerViewModel?.type
    }
    
    private func setUp() {
        self.title = "選手資訊"
        
        self.nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dataLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.gameImageView.clipsToBounds = true
        self.scrollView.alpha = 0
        
        for subviews in self.scrollView.subviews {
            if let webview = subviews as? WKWebView{
                webview.navigationDelegate = self
                webview.scrollView.delegate = self
                webview.scrollView.showsVerticalScrollIndicator = false
                webview.scrollView.showsHorizontalScrollIndicator = false
                webview.scrollView.bounces = false
                webview.isOpaque = false
            }
        }
        
        // change font size for screen size
        if UIScreen.main.nativeBounds.height <= 1136{
            self.nameLabel.font = UIFont.systemFont(ofSize: 18)
            self.dataLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }

    deinit {
        print("============")
        print("PlayerViewController Deinit")
        print("============")
    }
}

extension PlayerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide(animated: true, completion: { finished in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                self?.scrollView.alpha = 1
            })
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUD.hide(animated: true, completion: { finished in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                self?.scrollView.alpha = 1
            })
        })
    }
}

extension PlayerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
        }
    }
}
