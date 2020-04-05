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
    
    private var timer: Timer?
    
    var gameViewModel: GameViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        self.bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.streamButton.borderColor = .darkBlue
    }

    
    func setUp(){
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.title = "賽事資訊"
            
        self.streamButton.cornerRadius = 5
        self.streamButton.borderWidth = 0.5
        self.streamButton.tintColor = .darkBlue
        self.streamButton.borderColor = .darkBlue
        
        self.gameWebView.navigationDelegate = self
        self.gameWebView.scrollView.showsVerticalScrollIndicator = false
        self.gameWebView.isOpaque = false
        self.gameWebView.isHidden = true
        
        self.boxWebView.navigationDelegate = self
        self.boxWebView.scrollView.showsVerticalScrollIndicator = false
        self.boxWebView.isOpaque = false
        
        self.scoreboardWebView.navigationDelegate = self
        self.scoreboardWebView.scrollView.delegate = self
        self.scoreboardWebView.scrollView.showsVerticalScrollIndicator = false
        self.scoreboardWebView.isOpaque = false
        
        self.gameView.alpha = 0
        self.scoreView.alpha = 0
        self.segmentView.alpha = 0
    }
    
    private func bindViewModel() {
        self.loadHTML()
        
        self.gameViewModel?.errorHandleClosure = {
            HUD.hide(animated: true)
        }
        
        self.gameViewModel?.loadBoxHtml = { [weak self] boxHtml in
            guard let boxHtml = boxHtml else { return }
            
            self?.boxWebView.loadHTMLString(boxHtml, baseURL: nil)
        }
        
        self.gameViewModel?.loadGameHtml = { [weak self] (gameHtml, scoreBoardHtml) in
            guard let gameHtml = gameHtml, let scoreBoardHtml = scoreBoardHtml else { return }
            
            self?.gameWebView.loadHTMLString(gameHtml, baseURL: nil)
            self?.scoreboardWebView.loadHTMLString(scoreBoardHtml, baseURL: nil)
        }
        
        self.gameNumLabel.text = self.gameViewModel?.gameString
        self.guestImageView.image = UIImage(named: (self.gameViewModel?.guestImageString) ?? "")
        self.homeImageView.image = UIImage(named: (self.gameViewModel?.homeImageString) ?? "")
        self.guestScoreLabel.text = self.gameViewModel?.guestScore
        self.homeScoreLabel.text = self.gameViewModel?.homeScore
        self.placeLabel.text = self.gameViewModel?.place
        
        // check if today is game day and start timer
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let gameDate = dateFormatter.date(from: self.gameViewModel?.date ?? "")
        let weekDay = Date().weekday
        let hour = Date().hour
        let minute = Date().minute
        
        if (gameDate?.isInToday ?? false) {
            if hour >= 13 {
                self.setTimer()
            }
//            if weekDay == 7 && hour >= 12 {
//                self.setTimer()
//
//            } else if hour >= 18 && minute >= 30 {
//                self.setTimer()
//            }
        }
    }
    
    @objc func loadHTML() {
        HUD.show(.progress)
        self.gameViewModel?.loadHtml()
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.loadHTML), userInfo: nil, repeats: true)
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

extension GameViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hide(animated: true, completion: {finished in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
                [weak self] in
                    self?.gameView.alpha = 1
                    self?.scoreView.alpha = 1
                    self?.segmentView.alpha = 1
            })
        })
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUD.hide(animated: true, completion: {finished in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, animations: {
                [weak self] in
                    self?.gameView.alpha = 1
                    self?.scoreView.alpha = 1
                    self?.segmentView.alpha = 1
            })
        })
    }
    
}

extension GameViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 ) {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0.0)
        }
    }
}
