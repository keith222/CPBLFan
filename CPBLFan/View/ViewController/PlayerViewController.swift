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

enum playerType: String {
    case Hitter = "打擊成績"
    case Pitcher = "投球成績"
}

class PlayerViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    @IBOutlet weak var statsWebView: UIWebView!
    @IBOutlet weak var fieldingWebView: UIWebView!
    @IBOutlet weak var teamStatsWebView: UIWebView!
    @IBOutlet weak var singleGameWebView: UIWebView!
    
    @IBOutlet weak var statsWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fieldingWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var teamStatsWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var singleGameWebViewHeight: NSLayoutConstraint!
    
    var playerUrl: String!
    var type: playerType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.alpha = 0
        
        HUD.show(.progress)
        
        self.setUp()
        
        // set css for source from web
        let cssString = "<style>.std_tb{color: #333;font-size: 13px;line-height: 2.2em;}table.std_tb tr{background-color: #f8f8f8;}table.mix_x tr:nth-child(2n+1), table.std_tb tr.change{background-color: #e6e6e6;}table.std_tb th {background-color: #081B2F;color: #fff;font-weight: normal;padding: 0 6px;}table.std_tb td{padding: 0 6px;}table.std_tb th a, table.std_tb th a:link, table.std_tb th a:visited, table.std_tb th a:active {color: #fff;}a, a:link, a:visited, a:active {text-decoration: none;}</style>"
        
        // set navigation bar
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem.noTitleBarButtonItem()
        
        self.title = "選手資訊"
        self.nameLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.dataLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        self.statsLabel.text = type.rawValue
        
        let route = "\(APIService.CPBLSourceURL)\(playerUrl!)"
        APIService.request(.get, route: route, completionHandler: { text in
            guard let text = text else { return }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                var headUrl = doc.at_css(".player_info div img")?["src"]
                headUrl = ((headUrl?.hasSuffix(".jpg"))! || (headUrl?.hasSuffix(".png"))!) ? headUrl : headUrl?.appending("/phone/images/playerhead.png")
                
                let gameUrl = headUrl?.replacingOccurrences(of: "head", with: "game")
                self.headImageView.kf.setImage(with: URL(string: headUrl!))
                
                do{
                    let imageData = try Data(contentsOf: URL(string: gameUrl!)!)
                    self.gameImageView.image = UIImage(data: imageData)
                }catch{
                    self.gameImageView.image = UIImage(named: "logo")
                }
                
                
                var statsHtml = cssString + doc.css(".std_tb")[0].toHTML!
                statsHtml = statsHtml.replacingOccurrences(of: "display:none;", with: "")
                self.statsWebView.loadHTMLString(statsHtml, baseURL: nil)
                self.statsWebViewHeight.constant = CGFloat(30 * doc.css(".std_tb")[0].css("tr").count + 10)
                
                var fieldHtml = cssString + doc.css(".std_tb")[1].toHTML!
                fieldHtml = fieldHtml.replacingOccurrences(of: "詳細", with: "")
                self.fieldingWebView.loadHTMLString(fieldHtml, baseURL: nil)
                self.fieldingWebViewHeight.constant = CGFloat(30 * doc.css(".std_tb")[1].css("tr").count + 10)
                
                var teamHtml = cssString + doc.css(".std_tb")[doc.css(".std_tb").count - 2 ].toHTML!
                teamHtml = teamHtml.replacingOccurrences(of: "display:none;", with: "")
                self.teamStatsWebView.loadHTMLString(teamHtml, baseURL: nil)
                self.teamStatsWebViewHeight.constant = CGFloat(30 * (doc.css(".std_tb")[doc.css(".std_tb").count - 2 ].css("tr").count + 2) + 10)
                
                let singleHtml = cssString + doc.css(".std_tb")[doc.css(".std_tb").count - 1 ].toHTML!
                self.singleGameWebView.loadHTMLString(singleHtml, baseURL: nil)
                self.singleGameWebViewHeight.constant = CGFloat(30 * doc.css(".std_tb")[doc.css(".std_tb").count - 1 ].css("tr").count + 10)
                
                var playerInfo = (doc.at_css(".player_info_name")?.text) ?? (doc.at_css(".player_info3_name")?.text)
                playerInfo = playerInfo?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "球隊:", with: "｜")
                self.nameLabel.text = playerInfo
                
                var position = ""
                var batpitch = ""
                var height = ""
                var weight = ""
                var playerInfoOther = doc.css(".player_info_other tr:first-child td")
                if playerInfoOther.count < 1{
                    playerInfoOther = doc.css(".player_info3_other tr:first-child td")
                    position = (playerInfoOther[0].text?.components(separatedBy: ":")[1])!
                    batpitch = (playerInfoOther[1].text?.components(separatedBy: ":")[1])!
                    let playerInfoOther2 = doc.css(".player_info3_other tr:nth-child(2) td")
                    height = (playerInfoOther2[0].text?.components(separatedBy: ":")[1])!
                    height = height.replacingOccurrences(of: "\\(?\\)?", with: "", options: .regularExpression, range: (height.startIndex)..<(height.endIndex)).lowercased()
                    weight = (playerInfoOther2[1].text?.components(separatedBy: ":")[1])!
                    weight = weight.replacingOccurrences(of: "\\(?\\)?", with: "", options: .regularExpression, range: (weight.startIndex)..<(weight.endIndex)).lowercased()
                }else{
                    position = (playerInfoOther[0].text?.components(separatedBy: ":")[1])!
                    batpitch = (playerInfoOther[1].text?.components(separatedBy: ":")[1])!
                    height = (playerInfoOther[2].text?.components(separatedBy: ":")[1])!
                    height = height.replacingOccurrences(of: "\\(?\\)?", with: "", options: .regularExpression, range: (height.startIndex)..<(height.endIndex)).lowercased()
                    weight = (playerInfoOther[3].text?.components(separatedBy: ":")[1])!
                    weight = weight.replacingOccurrences(of: "\\(?\\)?", with: "", options: .regularExpression, range: (weight.startIndex)..<(weight.endIndex)).lowercased()
                }
                
                let infoString = "\(position)｜\(batpitch)｜\(height)/\(weight)"
                self.dataLabel.text = infoString
                
                // change font size for screen size
                if UIScreen.main.nativeBounds.height <= 1136{
                    self.nameLabel.font = UIFont.systemFont(ofSize: 18)
                    self.dataLabel.font = UIFont.systemFont(ofSize: 12)
                }
                
            } catch let error as NSError{
                print(error.localizedDescription)
            }
        })
    }
    
    deinit {
        print("============")
        print("PlayerViewController Deinit")
        print("============")
    }
    
    func setUp(){
        for subviews in self.scrollView.subviews as [UIView]{
            if let webview = subviews as? UIWebView{
                webview.delegate = self
                webview.scrollView.delegate = self
                webview.scrollView.showsVerticalScrollIndicator = false
                webview.scrollView.showsHorizontalScrollIndicator = false
                webview.scrollView.bounces = false
            }
        }
        
        self.gameImageView.clipsToBounds = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hide(animated: true, completion: {finished in
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.scrollView.alpha = 1
            })
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height), animated: false)
        }
    }
}
