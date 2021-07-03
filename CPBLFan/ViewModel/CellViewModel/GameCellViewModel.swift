//
//  GameCellViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/1/23.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation

struct GameCellViewModel {
    
    private let game: Game?
    
    var gameModel: Game? {
        return self.game
    }
    
    var num: String {
        let game = self.game?.game ?? 0
        switch game {
        case 0, -100:
             return "All Stars Game"
        case _ where game > 0:
            return "Game \(game)"
        case _ where game < -10:
            return "PlayOff Series G\(-(game % 10))"
        case _ where game < 0:
            return "Taiwan Series G\(-game)"
        default:
            return ""
        }
    }
    
    var place: String {
        guard let place = self.game?.place?.localized() else { return "" }
        return place
    }
    
    var streamUrl: URL? {
        return self.game?.stream?.url
    }
    
    var guestScore: String {
        guard let gScore = self.game?.g_score, !gScore.isEmpty else { return "--" }
        return gScore
    }
    
    var guestImageString: String {
        return self.game?.guest?.logoLocalizedString ?? ""
    }
    
    var homeScore: String {
        guard let hScore = self.game?.h_score, !hScore.isEmpty else { return "--" }
        return hScore
    }
    
    var homeImageString: String {
        return self.game?.home?.logoLocalizedString ?? ""
    }
    
    var timeString: String {
        guard let time = self.game?.time else { return "" }
        return time + ((TimeZone.current.secondsFromGMT() == 28800) ? "" : "(GMT+8)")
    }
    
    init(with game: Game?) {
        self.game = game
    }
}
