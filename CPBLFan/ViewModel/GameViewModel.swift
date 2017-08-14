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
import Firebase

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
        
        // for child change using
        var tempData: [(key: String, value: [Game])] = []
        
        let ref: DatabaseReference! = Database.database().reference()
        ref.child(year).child(month).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // check data if existed
            if let data = snapshot.value{
            
                // data jsonalize
                let jsonData = JSON(data)
                //print(jsonData)
                // data map to array
                let game = jsonData.map({ (game: (String, value: SwiftyJSON.JSON)) -> [Game] in
                    return game.value.map({ (data:(String, value: SwiftyJSON.JSON)) -> Game in
                        return Mapper<Game>().map(JSONObject: data.value.dictionaryObject)!
                    })
                })
                
                // make a dictionary
                var gameData: [String: [Game]] = [:]
                for (index, data) in jsonData.enumerated(){
                    if !data.1.isEmpty{
                        gameData[data.0] = game[index]
                    }
                }
                let sortedData = gameData.sorted(by: {Int($0.0.key)! < Int($0.1.key)!})
                tempData = sortedData
                handler(sortedData)
            }else{
                handler(nil)
            }

        })
        
        ref.child(year).child(month).observe(.childChanged, with: { (snapshot) in
            // check data if existed
            if let data = snapshot.value{

                // data jsonalize
                let jsonData = JSON(data)
                
                // get index
                let index = tempData.index(where: {
                    return $0.key == snapshot.key
                })
                
                // data map to array
                let game = jsonData.map({(game: (String, value: SwiftyJSON.JSON)) -> Game in
                    return Mapper<Game>().map(JSONObject: game.value.dictionaryObject)!
                })
                
                tempData[index!].value = game
                handler(tempData)
            }else{
                handler(nil)
            }
        })
    }
}

