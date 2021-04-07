//
//  AppState.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Foundation

enum Redux {}

protocol AutoTree {}

extension Redux {
    struct State: Codable, Equatable {
        var tabSelection: TabState = .init()
        var tappedProfiles: TappedProfilesState = .init()
        
        struct TappedProfilesState: Codable, Equatable {
            var profiles: [UUID: TappedProfile] = .init()
            
            struct Modification {
                var hi: String = ""
            }
        }
        
        struct TabState: Equatable {
            var currentTab: Tab = .history
        }
    }
}

extension Redux.State {
    // sourcery: skipPropertyGeneration
    enum CodingKeys: String, CodingKey {
        case tappedProfiles
    }
}

// sourcery: extension = "Redux"
struct StateTree: Codable, Equatable, AutoTree {
    struct TappedProfileState: Codable, Equatable {
        var profiles: [UUID: TappedProfile]

        struct Properties: Codable, Equatable {
            var count: Int
            var favourites: [UUID]
        }
    }

    struct TabState: Equatable {
        var currentTab: Tab
    }
}

// sourcery: extension = "Redux"
enum Action {
    enum Refined: AutoTree {
        enum TabAction {
            case setTab(to: Tab)
        }

        enum TappedProfilesAction {
            case add(TappedProfile)
            case remove(UUID)
            case removeMultiple(Set<UUID>)
        }

        case none
    }

    enum Raw {
        case loadState
        case saveState
    }
}
