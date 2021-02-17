//
//  AppState.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

enum Redux {}

extension Redux {
    struct State: Codable, Equatable {
        var tabSelection = TabSelection(currentTab: .history)
        var placeholder: String
        
        struct TabSelection: Equatable {
            var currentTab: Tab
        }
    }
}

extension Redux.State {
    enum CodingKeys: String, CodingKey {
        case placeholder
    }
}
