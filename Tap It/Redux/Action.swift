//
//  Action.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

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
                
            }
            
            case none
        }
        
        //MARK: - Raw Actions
        enum Raw {
            case loadState
            case save(State)
        }
    }
}
