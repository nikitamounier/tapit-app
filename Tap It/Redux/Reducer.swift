//
//  Reducer.swift
//  Tap It
//
//  Created by Nikita Mounier on 17/02/2021.
//

import Recombine

extension Redux {
    enum Reducer {
        // MARK: - Main Reducer
        static let main = MutatingReducer<State, Action.Refined> { state, action in
            switch action {
            case let .setState(appState):
                state = appState
                
            case let .tabAction(tabModification):
                state.tabSelection = tabReducer(state: state.tabSelection, action: tabModification) // pure reducer, because lightweight type
            
            case let .tappedProfilesAction(profilesModification):
                tappedProfilesReducer(state: &state.tappedProfiles, action: profilesModification) // inout reducer - doesn't replace dictionary every time
            
            case .none:
                break
            }
        }
        
        // MARK: - Tab Reducer
        private static let tabReducer = PureReducer<State.TabState, Action.Refined.TabAction> { _, tabAction -> State.TabState in
            switch tabAction {
            case let .setTab(to: tab):
                return .init(currentTab: tab)
            }
        }
        
        // MARK: - Tapped Profiles Reducer
        private static let tappedProfilesReducer = MutatingReducer<State.TappedProfilesState, Action.Refined.TappedProfilesAction> { state, profilesAction in
            switch profilesAction {
            case let .add(profile):
                state.profiles.updateValue(profile, forKey: profile.id)
            case let .remove(id):
                state.profiles[id] = nil
            case let .removeMultiple(ids):
                ids.forEach { id in state.profiles[id] = nil }
            }
        }
    }
}
