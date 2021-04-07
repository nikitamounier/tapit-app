//
//  Action.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Foundation

extension Redux {
    enum Action {
        // MARK: - Refined Actions
        enum Refined {
            case setState(State)
            
            case tabAction(TabAction)
            enum TabAction {
                case setTab(to: Tab)
            }
            
            case tappedProfilesAction(TappedProfilesAction)
            enum TappedProfilesAction {
                case add(TappedProfile)
                case remove(UUID)
                case removeMultiple(Set<UUID>)
            }
            
            case none
        }
        
        //MARK: - Raw Actions
        enum Raw {
            case loadState
            case saveState
        }
    }
}
