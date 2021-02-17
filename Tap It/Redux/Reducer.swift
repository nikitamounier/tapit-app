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
            case let .tabAction(modification):
                state.tabSelection = tabReducer(state: state.tabSelection, action: modification)
            }
        }
        
        private static let tabReducer = PureReducer<State.TabSelection, Action.Refined.TabAction> { _, tabAction in
            switch tabAction {
            case let .setTab(to: tab):
                return State.TabSelection(currentTab: tab)
            }
        }
    }
}
