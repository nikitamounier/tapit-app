//
//  Middleware.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Combine
import Recombine

extension Redux {
    static let middleware = Middleware<State, Action.Raw, Action.Refined> { state, action -> AnyPublisher<Action.Refined, Never> in
        
    }
}
