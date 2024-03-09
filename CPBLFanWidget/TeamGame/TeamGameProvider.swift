//
//  TeamGameProvider.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import WidgetKit
import FirebaseCore
import FirebaseDatabase
import os

struct TeamGameProvider: AppIntentTimelineProvider {
    private let ref: DatabaseReference = Database.database().reference()
    
    func placeholder(in context: Context) -> TeamGameEntry {
        TeamGameEntry(date: .now, entity: TeamEntity(id: ""), game: nil)
    }
    
    func snapshot(for configuration: TeamGameIntent, in context: Context) async -> TeamGameEntry {
        guard !configuration.team.id.isEmpty else {
            return TeamGameEntry(date: .now, entity: configuration.team, game: nil)
        }
        
        do {
            let game = try await fetchGameData(of: configuration.team.id)
            return TeamGameEntry(date: .now, entity: configuration.team, game: game)
            
        } catch(let error) {
            os_log("Error: %s", error.localizedDescription)
            return TeamGameEntry(date: .now, entity: configuration.team, game: nil)
        }
    }
    
    func timeline(for configuration: TeamGameIntent, in context: Context) async -> Timeline<TeamGameEntry> {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        
        guard !configuration.team.id.isEmpty else {
            return Timeline(entries: [TeamGameEntry(date: currentDate, entity: configuration.team, game: nil)], policy: .after(nextMidnight))
        }
        
        do {
            let game = try await fetchGameData(of: configuration.team.id)
            
            return Timeline(entries: [TeamGameEntry(date: currentDate, entity: configuration.team, game: game)], policy: .after(nextMidnight))
            
        } catch(let error) {
            os_log("Error: %s", error.localizedDescription)
            return Timeline(entries: [TeamGameEntry(date: currentDate, entity: configuration.team, game: nil)], policy: .after(nextMidnight))
        }
    }
    
    
    
    private func fetchGameData(of team: String) async throws -> Game? {
        let calendar = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        guard let year = calendar.year?.string, let month = calendar.month?.string, let day = calendar.day?.string else {
            return nil
        }
        
        do {
            let snapshot = try await ref.child(year).child(month).child(day).getData()
           
            guard let data = snapshot.children.allObjects as? [DataSnapshot], !data.isEmpty else {
                return nil
            }
            
            // convert firebase data to dictionary
            let jsonDictionary = data.compactMap({ ($0.value as? AnyObject) })
            
            // data jsonalize
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
            // data map to model
            let game = (try JSONDecoder().decode([Game].self, from: jsonData)).filter({ $0.home == team }).first
            
            return game
            
        } catch(let error) {
            os_log("Error: %s", error.localizedDescription)
            return nil
        }
    }
}

