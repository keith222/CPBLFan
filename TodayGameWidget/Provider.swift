//
//  Provider.swift
//  TodayGameWidgetExtension
//
//  Created by Yang Tun-Kai on 2022/3/16.
//  Copyright © 2022 Sparkr. All rights reserved.
//

import WidgetKit
import Firebase
import os

struct Provider: TimelineProvider {
    private let ref: DatabaseReference = Database.database().reference()
    
    func placeholder(in context: Context) -> GameEntry {
        GameEntry(date: Date(), games: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (GameEntry) -> ()) {
        let entry = GameEntry(date: Date(), games: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<GameEntry>) -> ()) {
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        getGameData(completionHandler: { games in
            let currentDate = Date()
            let midnight = Calendar.current.startOfDay(for: currentDate)
            let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            let entries = [GameEntry(date: currentDate, games: games)]
            let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
            completion(timeline)
        })
    }
    
    private func getGameData(completionHandler: @escaping ([Game]) -> Void) {
        let calendar = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let year = calendar.year?.string, let month = calendar.month?.string, let day = calendar.day?.string else {
            completionHandler([])
            return
        }
        
        ref.child(year).child(month).child(day)
            .observeSingleEvent(of: .value, with: { (snapshot) in
            // check data if existed
            guard let data = snapshot.children.allObjects as? [DataSnapshot], !data.isEmpty else {
                completionHandler([])
                return
            }
            
            do {
                // convert firebase data to dictionary
                let jsonDictionary = data.compactMap({ ($0.value as? AnyObject) })

//                print(jsonDictionary)
                // data jsonalize
                let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
                // data map to model
                let games = (try JSONDecoder().decode([Game].self, from: jsonData)).sorted(by: { ($0.game ?? 0) < ($1.game ?? 0) })
                
                completionHandler(games)
                
            } catch(let error) {
                completionHandler([])
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
}
