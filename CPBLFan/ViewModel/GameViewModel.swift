//
//  GameViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2017/2/3.
//  Copyright © 2017年 Sparkr. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper

class GameViewModel{
    
    var game: Int!
    var date: String!
    var guest: String!
    var home: String!
    var place: String!
    var g_score: String!
    var h_score: String!
    var stream: String!
    
    var source: JSON = JSON.null
    
    init(){}
    
    init(data: Game){
        self.game = data.game
        self.date = data.date
        self.guest = data.guest
        self.home = data.home
        self.place = data.place
        self.g_score = data.g_score
        self.h_score = data.h_score
        self.stream = data.stream
    }
    
    func fetchGame(at year:String, month: String, handler: @escaping (([(String,[Game])]?) -> ())){
        //let route = ""
        
        if source == JSON.null{
            let path:String = Bundle.main.path(forResource: "GameSchedule", ofType: "json")! as String
        
            let data: Data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            source = JSON(data: data)
        }

        guard source[year][month].exists() else {
            handler(nil)
            return
        }
        
        let game = source[year][month].map({ (game: (String, value: SwiftyJSON.JSON)) -> [Game] in
            return game.value.map({ (data:(String, value: SwiftyJSON.JSON)) -> Game in
                return Mapper<Game>().map(JSONObject: data.value.dictionaryObject)!
            })
        })
        
        var gameData: [String: [Game]] = [:]
        for (index, data) in source[year][month].enumerated(){
            gameData[data.0] = game[index]
        }

        let sortedData = gameData.sorted(by: {Int($0.0.key)! < Int($0.1.key)!})
        handler(sortedData)
    }
}

