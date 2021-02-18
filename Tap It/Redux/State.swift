//
//  AppState.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Foundation

enum Redux {}

extension Redux {
    struct State: Codable, Equatable {
        var tabSelection: TabState = .init(currentTab: .history)
        var tappedProfiles: TappedProfilesState = .init(profiles: [:])
        
        struct TappedProfilesState: Codable, Equatable {
            var profiles: [UUID: String] // for now, haven't made models yet
        }
        
        struct TabState: Equatable {
            var currentTab: Tab
        }
    }
}

extension Redux.State {
    enum CodingKeys: String, CodingKey {
        case tappedProfiles
    }
}
