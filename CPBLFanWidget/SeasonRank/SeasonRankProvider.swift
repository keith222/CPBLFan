//
//  SeasonRankProvider.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/1.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import SwiftUI
import WidgetKit
import FirebaseCore
import FirebaseDatabase
import os

struct SeasonRankProvider: TimelineProvider {
    
    @AppStorage("selectedSeason") private var selectedSeason: Int = 2
    
    private let ref: DatabaseReference = Database.database().reference()
    
    private var title: String {
        switch selectedSeason {
        case 0: return "1st"
        case 1: return "2nd"
        case 2: return "full"
        default: return "--"
        }
    }
    
    func placeholder(in context: Context) -> SeasonRankEntry {
        SeasonRankEntry(date: Date(), title: "--", ranks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SeasonRankEntry) -> ()) {
        fetchRankData(of: selectedSeason, completionHandler: { ranks in
            completion(SeasonRankEntry(date: Date(), title: title, ranks: ranks))
        })        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SeasonRankEntry>) -> Void) {
        fetchRankData(of: selectedSeason, completionHandler: { ranks in
            let currentDate = Date()
            let midnight = Calendar.current.startOfDay(for: currentDate)
            let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            
            completion(Timeline(entries: [SeasonRankEntry(date: currentDate, title: title, ranks: ranks)], policy: .after(nextMidnight)))
        })
    }
    
    private func fetchRankData(of season: Int, completionHandler: @escaping ([Rank]) -> Void) {
        var  seasonString = ""
        
        switch season {
        case 0: seasonString = "first"
        case 1: seasonString = "second"
        case 2: seasonString = "full"
        default: break
        }
        
        guard !seasonString.isEmpty else {
            completionHandler([])
            return
        }

        ref.child("rank").child(seasonString).observeSingleEvent(of: .value, with: { (snapshot) in
            // check data if existed
            guard let data = snapshot.children.allObjects as? [DataSnapshot], !data.isEmpty else {
                completionHandler([])
                return
            }

            do {
                // convert firebase data to rank array//
                let seasonData = try data.compactMap { snapshot in
                    return try snapshot.data(as: Rank.self)
                }
                
                completionHandler(seasonData.sorted(by: { $0.displayRank < $1.displayRank }))
                
            } catch(let error) {
                completionHandler([])
                os_log("Error: %s", error.localizedDescription)
            }
        })
    }
}

