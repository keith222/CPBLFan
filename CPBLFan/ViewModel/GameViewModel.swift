//
//  GameViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import Alamofire
import Kanna
import os

class GameViewModel{
    
    private let game: Game?
    private static let cssString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style> @media (prefers-color-scheme: dark){h3,p.box_note{color: #fff;}}body{margin: 0;font: -apple-system-body ;}.std_tb{color: #333;font-size: 13px;line-height: 2.2em;}table.std_tb tr{background-color: #f8f8f8;}table.mix_x tr:nth-child(2n+1), table.std_tb tr.change{background-color: #e6e6e6;}table.std_tb th {background-color: #081B2F;color: #fff;font-weight: normal;padding: 0 6px;}table.std_tb td{padding: 0 6px;}table.std_tb th a, table.std_tb th a:link, table.std_tb th a:visited, table.std_tb th a:active {color: #fff;}a, a:link, a:visited, a:active {text-decoration: none;color: #333}table.std_tb td.sub {padding-left: 1.2em;}.box_note{font-size: 13px;color:#081B2F;padding-left:15px;}h3{colro: #081B2F}</style>"
    
    private static let boardCss = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'></header><style>body{margin: 0;}table{width:100%;}.score_board{overflow:hidden;width:480px;}.gap_l20{margin-left:10px;}.score_board_side,.score_board_main{float:left;}table.score_table th{color:#b2b1b1}table.score_table th, table.score_table td{height:34px;padding:0 3px;}table.score_table tr:nth-child(2) td{border-bottom:1px solid #0d0d0d;}table.score_table td{color:#fff;}table.score_table td span {margin: 0 2px;padding: 1px 3px;width: 20px;}table.score_table tr:nth-child(3) td {border-top: 1px solid #575757;}</style>"
    
    private var inningCount = 1
    
    var gameNum: Int {
        return self.game?.game ?? 0
    }
    var date: String {
        return self.game?.date ?? ""
    }
    var guestImageString: String {
        return self.game?.guest ?? ""
    }
    var homeImageString: String {
        return self.game?.home ?? ""
    }
    var place: String {
        return self.game?.place ?? ""
    }
    var guestScore: String {
        guard let score = self.game?.g_score, !score.isEmpty else { return "--" }
        return score
    }
    var homeScore: String {
        guard let score = self.game?.h_score, !score.isEmpty else { return "--" }
        return score
    }
    var stream: URL? {
        return self.game?.stream?.url
    }
        
    var gameString: String {
        switch self.gameNum {
        case 0:
            return "All Stars Game"
            
        case _ where self.gameNum > 0:
            return "Game: \(self.gameNum)"
            
        case _ where self.gameNum < 0:
            return "Taiwan Series: G\(-self.gameNum)"
            
        default:
            return ""
        }
    }
    
    var loadGameHtml: ((String?, String?, Bool)->())?
    var loadBoxHtml: ((String?)->())?
    var errorHandleClosure: (()->())?
    
    init(with game: Game?){
        self.game = game
    }
    
    func loadHtml() {
        var gameID = self.gameNum
        let year = self.date.components(separatedBy: "-")[0]
        
        var gameType = "05"
        switch gameID {
        case _ where gameID > 0:
            gameType = "01"
            
        case 0:
            gameType = "02"
            gameID = 1
            
        case _ where gameID > -10:
            gameType = "03"
            gameID = -gameID
            
        default:
            gameID = (-gameID) % 10
        }
        
        self.loadGameLive(with: gameID, gameType, year)
        self.loadGameBox(with: gameID, gameType, year)
    }
    
    private func loadGameLive(with gameID: Int, _ gameType: String, _ year: String) {
        let route = "\(APIService.CPBLSourceURL)/games/play_by_play.html?&game_type=\(gameType)&game_id=\(gameID)&game_date=\(self.date)&pbyear=\(year)"
        
        APIService.request(.get, route: route, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                var gameHtml = GameViewModel.cssString
                var scoreboardHTML = GameViewModel.boardCss
                var isGameStarted = false
                
                if let game = doc.at_css(".std_tb:first-child"), let gameTable = game.toHTML {
                    if gameTable.contains("1上") {
                        isGameStarted = true
                        
                        if gameTable.contains("比賽結束") || gameTable.lowercased().contains("final") {
                            isGameStarted = false
                        }
                    }
                    
                    gameHtml += gameTable
                    gameHtml = gameHtml.replacingOccurrences(of: "display:none;", with: "")
                }
                
                if let scoreBoard = doc.at_css(".score_board")?.toHTML {
                    scoreboardHTML += scoreBoard
                }
                
                self?.loadGameHtml?(gameHtml, scoreboardHTML, isGameStarted)
                
            } catch(let error){
                self?.errorHandleClosure?()
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    private func loadGameBox(with gameID: Int, _ gameType: String, _ year: String) {
        // check if game day is earlier than today
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let checkDate = dateFormatter.date(from: self.date)
        guard checkDate! < Date() else { return }
        
        let boxRoute = "\(APIService.CPBLSourceURL)/games/box.html?&game_type=\(gameType)&game_id=\(gameID)&game_date=\(self.date)&pbyear=\(year)"
        
        APIService.request(.get, route: boxRoute, completionHandler: { [weak self] text in
            guard let text = text else {
                self?.errorHandleClosure?()
                return
            }
            
            do {
                let doc = try HTML(html: text, encoding: .utf8)
                
                // batting box
                var battingHtml = GameViewModel.cssString + "<h3 style='margin:20px 0 10px 10px;'>打擊成績</h3>"
                battingHtml += doc.css(".half_block.left > table")[0].toHTML ?? ""
                battingHtml += doc.css(".half_block.left > p.box_note")[0].toHTML ?? ""
                battingHtml += "<p></p>"
                battingHtml += doc.css(".half_block.right > table")[0].toHTML ?? ""
                battingHtml += doc.css(".half_block.right > p.box_note")[0].toHTML ?? ""
                
                //pitching box
                var pitchingHtml = "<h3 style='margin:20px 0 10px 10px;'>投手成績</h3>"
                pitchingHtml += doc.css(".half_block.left > table")[1].toHTML ?? ""
                pitchingHtml += "<p></p>"
                pitchingHtml += doc.css(".half_block.right > table")[1].toHTML ?? ""
                pitchingHtml += "<h3 style='margin:20px 0 10px 10px;'>賽後簡報</h3>"
                pitchingHtml += doc.css(".half_block.right > p.box_note")[2].toHTML ?? ""
                
                let boxHtml = battingHtml + pitchingHtml
                self?.loadBoxHtml?(boxHtml)
                
            } catch(let error) {
                self?.errorHandleClosure?()
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    private func getTeamName(with string: String) -> String {
        return ""
    }
}

