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

class PlayerViewModel {
    
    private var player: Player!
    
    var playerURL: String {
        let sourceURL = (Locale.autoupdatingCurrent.languageCode == "en") ? APIService.CPBLSourceEnURL : APIService.CPBLSourceURL
        return "\(sourceURL)\(player.playerUrl ?? "")"
    }
    
    let specialJSCode: String = """
            function changeStyle() {
                document.querySelectorAll('.PlayerHeader').forEach(function(a){a.remove()});
                document.querySelectorAll('.search').forEach(function(a){a.remove()});
                document.querySelectorAll('.record_table_swipe_guide').forEach(function(a){a.remove()});
                document.querySelectorAll('.record_table_scroll_ctrl').forEach(function(a){a.remove()});
                document.querySelectorAll('.PageTitle').forEach(function(a){a.remove()});
                document.querySelectorAll('.BtnTop').forEach(function(a){a.remove()});
                document.querySelectorAll('.born').forEach(function(a){a.remove()});
                document.querySelectorAll('.debut').forEach(function(a){a.remove()});
                document.querySelectorAll('.edu').forEach(function(a){a.remove()});
                document.querySelectorAll('.nationality').forEach(function(a){a.remove()});
                document.querySelectorAll('.original_name').forEach(function(a){a.remove()});
                document.querySelectorAll('.draft').forEach(function(a){a.remove()});
                document.querySelectorAll('.adGeek-author').forEach(function(a){a.remove()});
                document.querySelectorAll('.adGeek-popup').forEach(function(a){a.remove()});
                document.getElementById('Footer').remove();
                document.getElementById('MenuMobile').remove();
                document.getElementById('Header').remove();
                document.getElementById('Breadcrumbs').remove();
                document.getElementById('nav').remove();
                
                const ad = document.getElementById('adGeek-slot-div-gpt-ad-1633344967434-0');
                if (ad != null) ad.remove();
            
                const blocker = document.getElementById('mm-blocker').remove();
                if (blocker != null) blocker.remove();
            
                const cssTemplateString = `
                *{-webkit-touch-callout:none;-webkit-user-select:none}
                @media (prefers-color-scheme: dark) {
                 body {background-color: black; }
                 .DistTitle h3, .DistTitle .en { color: #0E90C4 }
                 .RecordTable th{background: #0E90C4}
                 .PlayerBrief dd .desc, .PlayerBrief dd .label {color: white}
                 .PlayerBrief > div {background-color: black}
                 .PlayerBrief {background: #787878}
                 .PlayerBrief dt {color: white}
                }
                @media (prefers-color-scheme: light) {
                  body {background-color: white;}
                  .DistTitle h3, .DistTitle .en {color: #081B2F }
                  .RecordTable th{background-color: #081B2F}
                  .PlayerBrief dd .desc{color: #081B2F}
                  .PlayerBrief dd .label{color: #666}
                  .PlayerBrief > div {background-color: white}
                  .PlayerBrief {background: #081B2F}
                  .PlayerBrief dt { color: #081B2F }
                }
                .PlayerBrief:after{background: none}
                .ContHeader {margin-top: -35px}
                `;
                const styleTag = document.createElement('style');
                styleTag.innerHTML = cssTemplateString;
                document.head.insertAdjacentElement(`beforeend`, styleTag)
            };
            changeStyle();
            setTimeout(() => {
                document.querySelectorAll('.adGeek-author').forEach(function(a){a.remove()});
                document.querySelectorAll('.adGeek-popup').forEach(function(a){a.remove()});
                
                const blocker = document.getElementById('mm-blocker').remove();
                if (blocker != null) blocker.remove();
            
                const ad = document.getElementById('adGeek-slot-div-gpt-ad-1633344967434-0');
                if (ad != null) ad.remove();
            }, 6000);
            """
    
    init(with player: Player) {
        self.player = player
    }
}
