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
    private let gameJSCode = ""
        
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
    
    var boxURL: String = ""
    var liveURL: String = ""
    
    var changeStyleJSCode: String {
        return """
            document.querySelectorAll('.PageTitle').forEach(function(a){a.remove()});
            document.querySelectorAll('.BtnTop').forEach(function(a){a.remove()});
            document.querySelectorAll('.GameSearch').forEach(function(a){a.remove()});
            document.querySelectorAll('.GameDateSelect').forEach(function(a){a.remove()});
            document.getElementById('Footer').remove();
            document.getElementById('MenuMobile').remove();
            document.getElementById('Header').remove();
            document.getElementById('Breadcrumbs').remove();
            document.getElementById('nav').remove();
            """
    }
    
    var scoreBoardHtml: String {
        return """
        <html>
        <header>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'>
        </header>
        <style>
            *{-webkit-touch-callout:none;-webkit-user-select:none}
        
            @media (prefers-color-scheme: dark) {
                body { background-color: #0E90C4; }
            }
            @media (prefers-color-scheme: light) {
                body { background-color: #081B2F; }
            }
          
            body {
                margin: 0;
                color: white;
                font-family: '-apple-system','Helvetica'
            }
        
            table {
                width: 100%;
                table-layout: auto;
                border-collapse: collapse;
                border-spacing: 0;
                font-family: '.SF UI Text';
            }
        
            .linescore_table {
                padding: 5px 10px;
                width: 500px;
            }
        
            .linescore_table td {
                height: 40px;
            }
        
            .linescore_table .linescore th span {
                display: block;
            }
        
            .linescore_table th {
                height: 30px;
                line-height: 30px;
            }
        
            .linescore td {
                text-align: center;
            }
        
            .team_name {
                width: fit-content;
            }
        
            .linescore.scrollable {
                width: 50%;
                margin-left: 10px;
                overflow-y: auto;
            }
        
            .linescore.fixed {
                width: 20%
            }
        
            .linescore, .team_name {
                float: left;
            }
        
            .linescore_table div:not(.team_name) th, .linescore_table>div:not(.team_name) .away td {
                border-bottom: 1px solid rgba(255, 255, 255, 0.3);
            }
        
            .card, .inning, .away td, .home td, .linescore th span {
                font-family: '-apple-system','Helvetica'
            }
        
            .short {
                width: 20px;
                height: 30px;
                background: linear-gradient(to bottom, rgba(255, 255, 255, 1) 0%, rgba(240, 240, 240, 1) 50%, rgba(255, 255, 255, 1) 100%);
                border-radius: 5px;
                display: block;
            }
        
            .team_name td img {
                width: 20px;
                height: 20px;
                margin: 5px 0;
            }
        </style>
        <body>%@</body>
        <script>
            document.querySelectorAll('.short').forEach(function (a) { a.remove(); });
            document.querySelectorAll('.team_name .away td').forEach(function(a){a.innerHTML = '<span class="short"><img src="data:application/png;base64,\(UIImage(named: (guestImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
            document.querySelectorAll('.team_name .home td').forEach(function(a){a.innerHTML = '<span class="short"><img src="data:application/png;base64,\(UIImage(named: (homeImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
        </script>
        </html>
        """
    }
    
    var boxJSCode: String {
        return """
            function changeStyle() {
                document.querySelectorAll('.en').forEach(function(element) {element.remove();});
                const cssTemplateString = `
                *{-webkit-touch-callout:none;-webkit-user-select:none}
                @media (prefers-color-scheme: dark) {
                 body { background-color: black; }
                 .GameBoxDetail > .tabs li.active a, .RecordTable th { background-color: #0E90C4 }
                 .DistTitle h3, .DistTitle .en { color: #0E90C4 }
                 .GameNote, .editable_content { color: white }
                }
                @media (prefers-color-scheme: light) {
                  body { background-color: white;}
                  .GameBoxDetail > .tabs li.active a, .RecordTable th {background-color: #081B2F }
                  .DistTitle h3, .DistTitle .en {color: #081B2F }
                  .GameNote, .editable_content {color: #333 }
                }
                .GameBoxDetail > .tabs li a { background-color: #808080; }
                .GameBoxDetail > .tabs li.active:after {border: none}
                .GameBoxDetail > .tabs li a > span {background: none; color: white}`;
                const styleTag = document.createElement('style');
                styleTag.innerHTML = cssTemplateString;
                document.head.insertAdjacentElement(`beforeend`, styleTag)
                \(changeStyleJSCode)
                setTimeout(() => {
                    if (app.curtGameDetail.GameStatus == 1 || app.curtGameDetail.GameStatus == 5 || app.curtGameDetail.GameStatus == 6) {
                        const content = (app.curtGameDetail.GameStatus == 1) ? "\("game_not_start".localized())" : "\("game_cancel".localized())"
                        window.webkit.messageHandlers['gameCancel'].postMessage(content)
                        return;
                    }
                    let score_board = document.getElementsByClassName('linescore_table');
                    if(score_board != null) {
                        score_board = score_board[0].outerHTML.toString()
                        window.webkit.messageHandlers['scoreBoard'].postMessage(score_board)
                        document.querySelectorAll('.GameHeader').forEach(function(a){a.remove()});
                    } else {
                        window.webkit.messageHandlers['scoreBoard'].postMessage(\"\")
                    }
                }, 1000);
            };
            changeStyle();
            """
    }
    
    var liveJSCode: String {
        return """
            app.switchTabs(3);
            setTimeout(changeStyle, 1000);
            function changeStyle() {
                \(changeStyleJSCode)
                const cssTemplateString = `
                *{-webkit-touch-callout:none;-webkit-user-select:none}
                            
                @media (prefers-color-scheme: dark) {
                 body { background-color: black; }
                 .InningPlays .title, .InningPlays .item.action { background: none; }
                 .GamePlaysDetail > .tabs li.active a, .InningPlays .title, .InningPlaysGroup .tabs li.active a { background-color: #0E90C4}
                 .InningPlays .item.action { background-color: #505050; }
                 .col_title h3, .GamePlaysDetail .tab_cont .col_title .en { color: #0E90C4}
                 .GameNote, .editable_content, .desc, .score, .InningPlaysGroup .tabs li a, .InningPlays .play .detail .call_desc, .InningPlays .item .call_desc a, .InningPlays .item .desc a, .InningPlays .item .desc a:focus, .InningPlays .item .desc a:hover { color: white; }
                
                }
                @media (prefers-color-scheme: light) {
                 body { background-color: white;}
                 .InningPlays .title, .InningPlays .item.action { background: none; }
                 .GamePlaysDetail > .tabs li.active a, .InningPlays .title, .InningPlaysGroup .tabs li.active a {background-color: #081B2F}
                 .InningPlays .item.action { background-color: #505050; }
                 .col_title h3, .GamePlaysDetail .tab_cont .col_title .en {color: #081B2F}
                 .GameNote, .editable_content {color: black}
                 .desc, .score, .InningPlaysGroup .tabs li a, .InningPlays .play .detail .call_desc, .InningPlays .item .call_desc a, .InningPlays .item .desc a, .InningPlays .item .desc a:focus, .InningPlays .item .desc a:hover { color: #333 }
                }
                                         
                .InningPlays .play .detail .no-pitch .call_desc, .InningPlays .play .detail .event .call_desc { background-color: transparent; }
                .InningPlays .item .desc a::after { height: 0px; }
                .InningPlays .item .desc a { font-weight: bold; }
                .GamePlaysDetail > .tabs li.active:after, .InningPlaysGroup .tabs, .InningPlaysGroup .tabs li.active:after {border: none}
                .GamePlaysDetail > .tabs li a > span {background: none; color: white}
                .InningPlaysGroup .tab_container { margin-right: 0px }
                .InningPlaysGroup .tabs { float: none }
                .InningPlaysGroup .tabs ul { overflow: scroll; white-space: nowrap; }
                .InningPlaysGroup .tabs li { margin-bottom: 4px; display: inline-block; }
                .InningPlaysGroup .tabs li a { border-radius: 0}
                .team_image { width: 25px; height: 25px; margin-top: 6px; }
                `;
                const styleTag = document.createElement('style');
                styleTag.innerHTML = cssTemplateString;
                document.head.insertAdjacentElement(`beforeend`, styleTag)
            
                document.querySelectorAll('.GameHeader').forEach(function(a){a.remove()});
                document.querySelectorAll('.GamePlaysDetail > .tabs').forEach(function(element){element.remove();});
                document.querySelectorAll('.batter_event').forEach(function(element){element.remove();});
                document.querySelectorAll('.no-pitch-action-remind').forEach(function(element){ element.remove();});
                document.querySelectorAll('.en').forEach(function(element) {element.remove();});
                document.querySelectorAll('.title > a').forEach(function(element){element.remove();});
                document.querySelectorAll('.player a').forEach(function(element){ element.removeAttribute('href');});
                document.querySelectorAll('.team.away').forEach(function(a){a.innerHTML = '<span><img class="team_image" src="data:application/png;base64,\(UIImage(named: (guestImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
                document.querySelectorAll('.team.home').forEach(function(a){a.innerHTML = '<span><img class="team_image" src="data:application/png;base64,\(UIImage(named: (homeImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
            
                document.querySelectorAll('.InningPlaysGroup .tabs li a').forEach(function(element){
                    element.addEventListener('click', e => {
                        document.querySelectorAll('.batter_event').forEach(function(element){element.remove();});
                        document.querySelectorAll('.no-pitch-action-remind').forEach(function(element){ element.remove();});
                        document.querySelectorAll('.title > a').forEach(function(element){element.remove();});
                        document.querySelectorAll('.player a').forEach(function(element){ element.removeAttribute('href');});
                        document.querySelectorAll('.InningPlays .item .desc a').forEach(function(element){ element.removeAttribute('href')});
                        document.querySelectorAll('.team.away').forEach(function(a){a.innerHTML = '<span><img class="team_image" src="data:application/png;base64,\(UIImage(named: (guestImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
                        document.querySelectorAll('.team.home').forEach(function(a){a.innerHTML = '<span><img class="team_image" src="data:application/png;base64,\(UIImage(named: (homeImageString.logoLocalizedString) )?.pngBase64String() ?? "")"></span>'});
                    });
                });
            };
            """
    }
    
    init(with game: Game?){
        self.game = game
        
        setHtml()
    }
    
    private func setHtml() {
        var gameID = self.gameNum
        let year = self.date.components(separatedBy: "-")[0]
        
        var gameType = ""
        switch gameID {
        case _ where gameID > 0:
            gameType = "A"
            
        case _ where gameID == 0 || gameID <= -100:
            gameType = "B"
            gameID = ((-gameID) % 9) + 1
            
        case _ where gameID > -10:
            gameType = "C"
            gameID = -gameID
            
        case _ where gameID < -10:
            gameType = "E"
            gameID = -gameID
        default:
            gameID = (-gameID) % 10
        }
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let checkDate = dateFormatter.date(from: self.date), checkDate <= Date() else { return }
        
        self.boxURL = "\(APIService.CPBLSourceURL)/box?year=\(year)&kindCode=\(gameType)&gameSno=\(gameID)"
        self.liveURL = "\(APIService.CPBLSourceURL)/box/live?year=\(year)&kindCode=\(gameType)&gameSno=\(gameID)"
    }
}

