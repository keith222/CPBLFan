//
//  GameViewController.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/7/11.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import UIKit
import SwifterSwift
import Kanna
import PKHUD

class GameViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var gameWebView: UIWebView!
    
    var gameViewModel: GameViewModel?
    var streamUrl: String?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.show(.progress)
        
        // set navigation bar
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.noTitleBarButtonItem()
        self.title = "賽事資訊"
        
        self.setUp()

        self.loadHTML()
        
        // check if today is game day and start timer
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let gameDate = dateFormatter.date(from: self.gameViewModel!.date)
//        let weekDay = Date().weekday
//        let hour = Date().hour
//        let minute = Date().minute

        if (gameDate?.isInToday)!{
            self.setTimer()
//            if weekDay == 7 && hour >= 17{
//                self.setTimer()
//            }else if hour >= 18 && minute >= 30{
//                self.setTimer()
//            }
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func setUp(){
        self.gameNumLabel.text = self.setGameString((self.gameViewModel?.game)!)
        self.guestImageView.image = UIImage(named: (self.gameViewModel?.guest)!)
        self.homeImageView.image = UIImage(named: (self.gameViewModel?.home)!)
        self.guestScoreLabel.text = (self.gameViewModel?.g_score.isEmpty)! ? "--" : self.gameViewModel?.g_score
        self.homeScoreLabel.text = (self.gameViewModel?.h_score.isEmpty)! ? "--" : self.gameViewModel?.h_score
        self.placeLabel.text = self.gameViewModel?.place
        self.streamUrl = self.gameViewModel?.stream
        
        self.gameWebView.delegate = self
        self.gameWebView.scrollView.showsVerticalScrollIndicator = false
        self.gameWebView.alpha = 0
        
        self.gameView.alpha = 0
    }
    
    func setGameString(_ gameNo: Int)->String{
        var numString = ""
        switch gameNo {
        case 0:
            numString = "All Stars Game"
        case _ where gameNo > 0:
            numString = "Game: \(gameNo)"
        case _ where gameNo < 0:
            numString = "Taiwan Series: G\(-gameNo)"
        default:
            break
        }
        
        return numString
    }

    func loadHTML() {
        var gameID = self.gameViewModel!.game
        let gameDate = self.gameViewModel!.date
        let year = self.gameViewModel!.date.components(separatedBy: "-")[0]
        
        var gameType = ""
        if gameID! > 0 {
            gameType = "01"
        }else if gameID! == 0 {
            gameType = "02"
            gameID = 1
        }else {
            gameType = "03"
            gameID = -gameID!
        }
        
        let route = "\(APIService.CPBLSourceURL)/games/play_by_play.html?&game_type=\(gameType)&game_id=\(gameID!)&game_date=\(gameDate!)&pbyear=\(year)"
        let cssString = "<style>.std_tb{color: #333;font-size: 13px;line-height: 2.2em;}table.std_tb tr{background-color: #f8f8f8;}table.mix_x tr:nth-child(2n+1), table.std_tb tr.change{background-color: #e6e6e6;}table.std_tb th {background-color: #545454;color: #fff;font-weight: normal;padding: 0 6px;}table.std_tb td{padding: 0 6px;}table.std_tb th a, table.std_tb th a:link, table.std_tb th a:visited, table.std_tb th a:active {color: #fff;}a, a:link, a:visited, a:active {text-decoration: none;}</style>"
        APIService.request(.get, route: route, completionHandler: { text in
            if let doc = HTML(html: text, encoding: .utf8){
                var gameHtml = cssString
                
                if let gameTable = doc.at_css(".std_tb:first-child") {
                    gameHtml = gameHtml + gameTable.toHTML!
                    gameHtml = gameHtml.replacing("display:none;", with: "")
                    self.gameWebView.loadHTMLString(gameHtml, baseURL: nil)
                    
                }else{
                   self.gameWebView.loadHTMLString(gameHtml, baseURL: nil)
                }
            }
        })
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.loadHTML), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide(animated: true, completion: {finished in
            UIView.animate(withDuration: 0.5, animations: {
                webView.alpha = 1
                self.gameView.alpha = 1
            })
        })
    }
    
    @IBAction func streamAction(_ sender: UIButton) {
        if let url = self.streamUrl, !url.isEmpty{
            UIApplication.shared.openURL(URL(string: url)!)
        }else{
            UIAlertController(title: "提示", message: "目前尚無串流位址。", defaultActionButtonTitle: "確定", tintColor: nil).show()
        }
    }


}
