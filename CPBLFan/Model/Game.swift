//
//  Game.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation

struct Game: Codable {
    
    let game: Int?
    let date: String?
    let guest: String?
    let home: String?
    let place: String?
    let gScore: String?
    let hScore: String?
    let stream: String?
    let time: String?
    
    private enum CodingKeys: String, CodingKey {
        case game, date, guest,home, place, gScore = "g_score", hScore = "h_score", stream, time
    }
}
