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
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var gameNumLabel: UILabel!
    @IBOutlet weak var streamButton: UIButton!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var guestImageView: UIImageView!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var guestScoreLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var scoreboardWebView: UIWebView!
    @IBOutlet weak var gameWebView: UIWebView!
    @IBOutlet weak var boxWebView: UIWebView!
    @IBOutlet weak var selectSegment: UISegmentedControl!
    
    
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
    
    deinit {
        print("============")
        print("GameViewController Deinit")
        print("============")
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
        
        self.boxWebView.delegate = self
        self.boxWebView.scrollView.showsVerticalScrollIndicator = false
        //self.boxWebView.alpha = 0
        
        self.scoreboardWebView.delegate = self
        
        self.gameView.alpha = 0
        self.scoreView.alpha = 0
        self.segmentView.alpha = 0
        
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
        
        let cssString = "<style>.std_tb{color: #333;font-size: 13px;line-height: 2.2em;}table.std_tb tr{background-color: #f8f8f8;}table.mix_x tr:nth-child(2n+1), table.std_tb tr.change{background-color: #e6e6e6;}table.std_tb th {background-color: #081B2F;color: #fff;font-weight: normal;padding: 0 6px;}table.std_tb td{padding: 0 6px;}table.std_tb th a, table.std_tb th a:link, table.std_tb th a:visited, table.std_tb th a:active {color: #fff;}a, a:link, a:visited, a:active {text-decoration: none;color: #333}table.std_tb td.sub {padding-left: 1.2em;}.box_note{font-size: 13px;color:#081B2F;padding-left:15px;}</style>"
        
        
        let route = "\(APIService.CPBLSourceURL)/games/play_by_play.html?&game_type=\(gameType)&game_id=\(gameID!)&game_date=\(gameDate!)&pbyear=\(year)"
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
                
                if let scoreBoard = doc.at_css(".score_board") {
                    let boardCss = "<style>table{width:100%;}.score_board{background-color: #081B2F;overflow:hidden;}.gap_l20{margin-left:10px;}.score_board_side,.score_board_main{float:left;}table.score_table th{color:#b2b1b1}table.score_table th, table.score_table td{height:34px;padding:0 3px;}table.score_table tr:nth-child(2) td{border-bottom:1px solid #0d0d0d;}table.score_table td{color:#fff;}table.score_table td span {margin: 0 2px;padding: 1px 3px;width: 20px;}table.score_table tr:nth-child(3) td {border-top: 1px solid #575757;}</style>"
                    
                    let scoreboardHTML = boardCss + scoreBoard.toHTML!
                    self.scoreboardWebView.loadHTMLString(scoreboardHTML, baseURL: nil)
                }
            }
        })
        
        // check if game day is earlier than today
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let checkDate = dateFormatter.date(from: gameDate!)
        guard checkDate! < Date() else { return }
        
        let boxRoute = "\(APIService.CPBLSourceURL)/games/box.html?&game_type=\(gameType)&game_id=\(gameID!)&game_date=\(gameDate!)&pbyear=\(year)"
        
        APIService.request(.get, route: boxRoute, completionHandler: {text in
            if let doc = HTML(html: text, encoding: .utf8){
                // batting box
                var battingHtml = cssString + "<h3 style='color:#081B2F;margin:20px 0 10px 10px;'>打擊成績</h3>"
                battingHtml += doc.css(".half_block.left > table")[0].toHTML!
                battingHtml += doc.css(".half_block.left > p.box_note")[0].toHTML!
                battingHtml += "<p></p>"
                battingHtml += doc.css(".half_block.right > table")[0].toHTML!
                battingHtml += doc.css(".half_block.right > p.box_note")[0].toHTML!
                
                //pitching box
                var pitchingHtml = "<h3 style='color:#081B2F;margin:20px 0 10px 10px;'>投手成績</h3>"
                pitchingHtml += doc.css(".half_block.left > table")[1].toHTML!
                pitchingHtml += "<p></p>"
                pitchingHtml += doc.css(".half_block.right > table")[1].toHTML!
                pitchingHtml += "<h3 style='color:#081B2F;margin:20px 0 10px 10px;'>賽後簡報成績</h3>"
                pitchingHtml += doc.css(".half_block.right > p.box_note")[2].toHTML!
                
                let boxHtml = battingHtml + pitchingHtml
                self.boxWebView.loadHTMLString(boxHtml, baseURL: nil)
            }
        })
    }
    
    func setTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.loadHTML), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide(animated: true, completion: {finished in
            UIView.animate(withDuration: 0.5, animations: { [weak self] _ in
                webView.alpha = 1
                self?.gameView.alpha = 1
                self?.scoreView.alpha = 1
                self?.segmentView.alpha = 1
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
    


}
