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

    @IBOutlet weak var playerWebView: WKWebView!

    var playerViewModel: PlayerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.setUp()
        self.bindViewModel()
    }
        
    private func bindViewModel() {
        guard let url = self.playerViewModel?.playerURL.url else {
            HUD.hide(animated: true)
            return
        }
        
        let request = URLRequest(url: url)
        self.playerWebView.load(request)
    }
    
    private func setUp() {
        self.title = "選手資訊".localized()
    
        self.playerWebView.navigationDelegate = self
        self.playerWebView.scrollView.showsHorizontalScrollIndicator = false
        self.playerWebView.isOpaque = false
    }

    deinit {
        print("============")
        print("PlayerViewController Deinit")
        print("============")
    }
}

extension PlayerViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let jsString = self.playerViewModel?.specialJSCode else {
            HUD.hide(animated: true)
            return
        }
        
        webView.evaluateJavaScript(jsString, completionHandler: { [weak self] (any,error) in
            if error != nil {
                self?.performAlert(with: error?.localizedDescription)
                return
            }
            
            HUD.hide(animated: true, completion: { finished in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: { [weak self] in
                    self?.playerWebView.alpha = 1
                })
            })
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.performAlert(with: error.localizedDescription)
    }
}
