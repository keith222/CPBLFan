//
//  GameViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/7/11.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import Kanna
import PKHUD
import WebKit

class GameViewController: BaseViewController {
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var scoreboardWebView: WKWebView!
    @IBOutlet weak var boxWebView: WKWebView!
    @IBOutlet weak var gameWebView: WKWebView!
    @IBOutlet weak var selectSegment: UISegmentedControl!
    @IBOutlet weak var cancelLabel: UILabel!
    
    var gameViewModel: GameViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.bindViewModel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.streamButton.borderColor = .darkBlue
    }
    
    
    func setUp(){
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.title = "賽事資訊".localized()
        
        self.streamButton.cornerRadius = 5
        self.streamButton.borderWidth = 0.5
        self.streamButton.tintColor = .darkBlue
        self.streamButton.borderColor = .darkBlue
        
        self.scoreView.backgroundColor = .darkBlue
        
        self.gameWebView.navigationDelegate = self
        self.gameWebView.scrollView.showsVerticalScrollIndicator = false
        self.gameWebView.isOpaque = false
        self.gameWebView.isHidden = true
                
        self.boxWebView.navigationDelegate = self
        self.boxWebView.scrollView.showsVerticalScrollIndicator = false
        self.boxWebView.configuration.userContentController.add(self, name: "scoreBoard")
        self.boxWebView.configuration.userContentController.add(self, name: "gameCancel")
        self.boxWebView.isOpaque = false
        
        self.scoreboardWebView.navigationDelegate = self
        self.scoreboardWebView.scrollView.delegate = self
        self.scoreboardWebView.scrollView.showsVerticalScrollIndicator = false
        self.scoreboardWebView.isOpaque = false
        
        self.gameView.alpha = 0
        self.scoreView.alpha = 0
        self.segmentView.alpha = 0
        self.boxWebView.alpha = 0
        self.gameWebView.alpha = 0
    }
    
    private func bindViewModel() {
        self.gameNumLabel.text = self.gameViewModel?.gameString
        self.guestImageView.image = UIImage(named: (self.gameViewModel?.guestImageString.logoLocalizedString) ?? "")
        self.homeImageView.image = UIImage(named: (self.gameViewModel?.homeImageString.logoLocalizedString) ?? "")
        self.guestScoreLabel.text = self.gameViewModel?.guestScore
        self.homeScoreLabel.text = self.gameViewModel?.homeScore
        self.placeLabel.text = self.gameViewModel?.place.localized()
        
        guard let boxURL = self.gameViewModel?.boxURL.url else {
            HUD.hide()
            return
        }
        self.boxWebView.load(URLRequest(url: boxURL))
    }
    
    @IBAction func streamAction(_ sender: UIButton) {
        if let url = self.gameViewModel?.stream {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else{
            self.performAlert(with: "目前尚無串流位址。")            
        }
    }
    
    @IBAction func indexChangedAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.boxWebView.isHidden = false
            self.gameWebView.isHidden = true
            
        case 1:
            self.boxWebView.isHidden = true
            self.gameWebView.isHidden = false
        default:
            break
        }
    }
    
    deinit {
        print("============")
        print("GameViewController Deinit")
        print("============")
    }
}

extension GameViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "scoreBoard", let html = message.body as? String {
            let scoreBoard = self.gameViewModel?.scoreBoardHtml.replacingOccurrences(of: "%@", with: html) ?? html
            self.scoreboardWebView.loadHTMLString(scoreBoard, baseURL: nil)
        }
        
        if message.name == "gameCancel", let content = message.body as? String {
            HUD.hide(animated: true, completion: { [weak self] finished in
                self?.cancelLabel.text = content
                self?.cancelLabel.isHidden = false
            })
        }
        
    }
}

extension GameViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == self.boxWebView, let jsCode = self.gameViewModel?.boxJSCode {
            webView.evaluateJavaScript(jsCode, completionHandler: { [weak self] (any,error) in
                print(error)
                if error != nil {
                    self?.performAlert(with: error?.localizedDescription)
                    return
                }
                
                guard let liveURL = self?.gameViewModel?.liveURL.url else { return }
                
                self?.gameWebView.load(URLRequest(url: liveURL))
            })
        }

        if webView == self.gameWebView, let jsCode = self.gameViewModel?.liveJSCode {
            webView.evaluateJavaScript(jsCode, completionHandler: { [weak self] (any,error) in
                if error != nil {
                    self?.performAlert(with: error?.localizedDescription)
                    return
                }
            })
        }

        if webView == self.scoreboardWebView {
            HUD.hide(animated: true, completion: { [weak self] finished in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
                    self?.gameView.alpha = 1
                    self?.scoreView.alpha = 1
                    self?.segmentView.alpha = 1
                    self?.boxWebView.alpha = 1
                    self?.gameWebView.alpha = 1
                })
            })
        }
    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.performAlert(with: error.localizedDescription)
    }
    
}

extension GameViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 ) {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0.0)
        }
    }
}
