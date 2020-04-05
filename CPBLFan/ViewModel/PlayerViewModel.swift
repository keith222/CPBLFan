//
//  PlayerViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/2/9.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Kanna

class PlayerViewModel {
    
    typealias HtmlSource = (html: String, height: CGFloat)
    
    private var player: Player!
    // set css for source from web
    private let cssString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style>body{margin: 0;}.std_tb{color: #333;font-size: 13px;line-height: 2.2em;}table.std_tb tr{background-color: #f8f8f8;}table.mix_x tr:nth-child(2n+1), table.std_tb tr.change{background-color: #e6e6e6;}table.std_tb th {background-color: #081B2F;color: #fff;font-weight: normal;padding: 0 6px;}table.std_tb td{padding: 0 6px;}table.std_tb th a, table.std_tb th a:link, table.std_tb th a:visited, table.std_tb th a:active {color: #fff;}a, a:link, a:visited, a:active {text-decoration: none;}</style>"
    
    var type: String {
        return self.player.type?.rawValue ?? ""
    }
    
    var loadHtmlStringClosure: ((HtmlSource, HtmlSource, HtmlSource, HtmlSource, String, String)->())?
    var loadImageHtmlClosure: ((String?, String?)->())?
    var errorHandleClosure: (()->())?
    
    init(with player: Player) {
        self.player = player
        self.fetchSource()
    }
    
    func fetchSource() {
        let route = "\(APIService.CPBLSourceURL)\(self.player.playerUrl ?? "")"
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                var headUrl = doc.at_css(".player_info div img")?["src"]
                headUrl = ((headUrl?.hasSuffix(".jpg"))! || (headUrl?.hasSuffix(".png"))!) ? headUrl : headUrl?.appending("/phone/images/playerhead.png")
                let gameUrl = headUrl?.replacingOccurrences(of: "head", with: "game")
                self?.loadImageHtmlClosure?(headUrl, gameUrl)
                                
                
                var statsHtml = "\(self?.cssString ?? "")\(doc.css(".std_tb")[0].toHTML ?? "")"
                statsHtml = statsHtml.replacingOccurrences(of: "display:none;", with: "")
                let statsHeight = CGFloat(30 * doc.css(".std_tb")[0].css("tr").count + 10)
                let statsContent = (html: statsHtml, height: statsHeight)
              
                var fieldHtml = "\(self?.cssString ?? "")\(doc.css(".std_tb")[1].toHTML ?? "")"
                fieldHtml = fieldHtml.replacingOccurrences(of: "詳細", with: "")
                let fieldHeight = CGFloat(30 * doc.css(".std_tb")[1].css("tr").count + 10)
                let fieldContent = (html: fieldHtml, height: fieldHeight)
                
                var teamHtml = "\(self?.cssString ?? "")\(doc.css(".std_tb")[doc.css(".std_tb").count - 2 ].toHTML ?? "")"
                teamHtml = teamHtml.replacingOccurrences(of: "display:none;", with: "")
                let teamHeight = CGFloat(30 * (doc.css(".std_tb")[doc.css(".std_tb").count - 2 ].css("tr").count + 2) + 10)
                let teamContent = (html: teamHtml, height: teamHeight)
                
                let singleHtml = "\(self?.cssString ?? "")\(doc.css(".std_tb")[doc.css(".std_tb").count - 1 ].toHTML ?? "")"
                let singleHeight = CGFloat(30 * doc.css(".std_tb")[doc.css(".std_tb").count - 1 ].css("tr").count + 10)
                let singleContent = (html: singleHtml, singleHeight)
                
                var playerInfo = (doc.at_css(".player_info_name")?.text) ?? (doc.at_css(".player_info3_name")?.text) ?? ""
                playerInfo = playerInfo.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "球隊:", with: "｜")
                
                var position = "", batpitch = "", height = "", weight = ""
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
                
                self?.loadHtmlStringClosure?(statsContent, fieldContent, teamContent, singleContent, playerInfo, infoString)
                
            } catch (let error){
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    
}
