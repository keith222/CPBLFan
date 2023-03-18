//
//  GameScheduleViewModel.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/2/15.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation
import os
import Alamofire
import Firebase
import SwifterSwift

class GameScheduleViewModel {
    
    enum Sequence {
        case previous, next
    }
    
    typealias GameScheduleCellViewModel = (GameHeaderCellViewModel, [GameCellViewModel])
    typealias GameItem = [String: [Game]]
    
    private let ref: DatabaseReference = Database.database().reference()
    private var gameScheduleCellViewModels: [GameScheduleCellViewModel] = [] {
        didSet {
            self.reloadTableViewClosure?(gameScheduleCellViewModels)
        }
    }

    var numberOfCells: Int {
        return gameScheduleCellViewModels.count
    }
    
    var reloadTableViewClosure: (([GameScheduleCellViewModel])->())?
    var errorHandleClosure: ((String?)->())?
    var updateDateClosure:  ((String?)->())?
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    
    init(){
        self.initDate()
        self.fetchGame()
    }
    
    func fetchGame(){
        self.gameScheduleCellViewModels.removeAll()

        ref.child(year.string).child(month.string).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            // check data if existed
            guard let data = snapshot.children.allObjects as? [DataSnapshot], !data.isEmpty else {
                self?.gameScheduleCellViewModels = []
                return
            }
            
            do {
                
                // convert firebase data to dictionary
                let jsonDictionary = data.compactMap({ ($0.key, ($0.value as? [AnyObject])) })
                    .reduce(into: [String: [AnyObject]](), { $0.updateValue($1.1, forKey: $1.0) })

                // data jsonalize
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
                // data map to model
                let games = (try JSONDecoder().decode(GameItem.self, from: jsonData)).sorted(by: { (Int($0.key) ?? 0) < (Int($1.key) ?? 0) })
                guard let year = self?.year, let month = self?.month else {
                    self?.errorHandleClosure?(nil)
                    return
                }
                
                self?.processFetched(year, month: month, gameItems: games)

            } catch(let error) {
                print(error)
                self?.errorHandleClosure?(error.localizedDescription)
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
    
    func updateTime(with timing: Sequence) {
        switch timing {
        case .previous:
            self.month -= 1
            if self.month < 2{
                self.year -= 1
                self.month = 12
            }
            
        case .next:
            self.month += 1
            if self.month > 12{
                self.year += 1
                self.month = 2
            }
        }
    }
    
    func getCellViewModels() -> [GameScheduleCellViewModel] {
        return self.gameScheduleCellViewModels
    }
    
    func getCellViewModel(at index: Int) -> GameScheduleCellViewModel {
        return self.gameScheduleCellViewModels[index]
    }
    
    func getGameViewModel(at section: Int, and index: Int) -> GameViewModel {
        let game = self.getCellViewModel(at: section).1[index].gameModel
        return GameViewModel(with: game)
    }
    
    private func processFetched(_ year: Int, month: Int, gameItems: [(String, [Game])]) {
        var viewModels = [GameScheduleCellViewModel]()
        for gameItem in gameItems.enumerated() {
            viewModels.append(createScheduleCellViewModel(with: year, month, gameItem.element.0, and: gameItem.element.1))
        }
        self.gameScheduleCellViewModels.append(contentsOf: viewModels)
    }
    
    private func createScheduleCellViewModel(with year: Int, _ month: Int, _ day: String,  and games: [Game]) -> GameScheduleCellViewModel {
        let gameHeaderCellViewModel = createGameHeaderCellViewModel(with: year, month, and: day)
        var gameCellViewModels = [GameCellViewModel]()
        for game in games {
            gameCellViewModels.append(createGameCellViewModel(with: game))
        }
        return (gameHeaderCellViewModel, gameCellViewModels)
    }
    
    private func createGameHeaderCellViewModel(with year: Int, _ month: Int, and day: String) -> GameHeaderCellViewModel {
        return GameHeaderCellViewModel(year: year, month: month, day: day.int)
    }
    
    private func createGameCellViewModel(with game: Game) -> GameCellViewModel {
        return GameCellViewModel(with: game)
    }
    
    private func initDate() {
        // set schedule year and month
        let calendar = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        self.year = calendar.year ?? 0
        self.month = calendar.month ?? 0
        self.day = calendar.day ?? 0
        
        // because of baseball season is from 2 to 12
        if self.month < 2 {
            self.year -= 1
            self.month = 12
        }
    }
}
