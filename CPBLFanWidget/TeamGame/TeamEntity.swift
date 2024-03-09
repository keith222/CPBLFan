//
//  TeamEntity.swift
//  CPBLFanWidgetExtension
//
//  Created by Yang Tun-Kai on 2024/3/6.
//  Copyright © 2024 Sparkr. All rights reserved.
//

import Foundation
import AppIntents

struct TeamEntity: AppEntity {
    
    var id: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Team"
    static var defaultQuery = TeamEntityQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: getTeam(by: id))
    }
        
    static let allTeams: [TeamEntity] = [
        TeamEntity(id: ""),
        TeamEntity(id: "-1"),
        TeamEntity(id: "1"),
        TeamEntity(id: "2"),
        TeamEntity(id: "3-0"),
        TeamEntity(id: "4"),
        TeamEntity(id: "6")
    ]
    
    private func getTeam(by id: String) -> LocalizedStringResource {
        switch id {
        case "-1": return "AAA011"
        case "1": return "ACN011"
        case "2": return "ADD011"
        case "3-0": return "AJL011"
        case "4": return "AEO011"
        case "6": return "AKP011"
        default: return "none"
        }
    }
}

struct TeamEntityQuery: EntityQuery {
    
    func entities(for identifiers: [TeamEntity.ID]) async throws -> [TeamEntity] {
        TeamEntity.allTeams.filter({ identifiers.contains($0.id)})
    }
    
    func suggestedEntities() async throws -> [TeamEntity] {
        TeamEntity.allTeams.filter({ $0.id != "" })
    }
    
    func defaultResult() async -> TeamEntity? {
        TeamEntity(id: "")
    }
    
}
