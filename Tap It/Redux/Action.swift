//
//  Action.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

extension Redux {
    enum Action {
        enum Refined {
            case tabAction(TabAction)
            
            enum TabAction {
                case setTab(to: Tab)
            }
        }
        
        enum Raw {
            
        }
    }
}
