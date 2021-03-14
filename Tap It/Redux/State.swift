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
    struct State: Codable, Equatable, AutoTree {
        var tabSelection: TabState = .init()
        var tappedProfiles: TappedProfilesState = .init()
        
        struct TappedProfilesState: Codable, Equatable {
            var profiles: [UUID: TappedProfile] = [:]
        }
        
        struct TabState: Equatable {
            var currentTab: Tab = .history
        }
    }
}

extension Redux.State {
    enum CodingKeys: String, CodingKey {
        case tappedProfiles
    }
}
