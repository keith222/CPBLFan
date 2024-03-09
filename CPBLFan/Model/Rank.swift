//
//  Rank.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/1/7.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation

struct Season: Codable {
    let first: [Rank]
    let second: [Rank]
    let full: [Rank]
}

struct Rank: Codable {
    
    let team: String
    let rank: Int
    let win: Int
    let lose: Int
    let tie: Int
    let displayRank: Int
    let winningRate: Double
    let gameBehind: Double
    
    private enum CodingKeys: String, CodingKey {
        case team, rank, win, lose, tie, displayRank = "display_rank", winningRate = "winning_rate", gameBehind = "game_behind"
    }
}
