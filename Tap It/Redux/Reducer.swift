//
//  Reducer.swift
//  Tap It
//
//  Created by Nikita Mounier on 17/02/2021.
//

import Recombine

extension Redux {
    enum Reducer {
        static let main = MutatingReducer<State, Action.Refined> { state, action in
            switch action {
            case let .setState(appState):
                state = appState
                
            case let .tabAction(modification):
                state.tabSelection = tabReducer(state: state.tabSelection, action: modification) // pure reducer, because lightweight type
                
            case let .tappedProfilesAction(modification):
                tappedProfilesReducer(state: &state.tappedProfiles, action: modification) // inout reducer - wouldn't want to replace dictionary every time
            
            case .none:
                break
            }
        }
        
        private static let tabReducer = PureReducer<State.TabState, Action.Refined.TabAction> { _, tabAction in
            switch tabAction {
            case let .setTab(to: tab):
                return State.TabState(currentTab: tab)
            }
        }
        
        private static let tappedProfilesReducer = MutatingReducer<State.TappedProfilesState, Action.Refined.TappedProfilesAction> { state, profilesAction in
            
        }
    }
}
