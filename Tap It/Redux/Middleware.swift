//
//  Middleware.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Combine
import Foundation
import Recombine

extension Redux {
    static let middleware = Middleware<State, Action.Raw, Action.Refined> { state, action -> AnyPublisher<Action.Refined, Never> in
        switch action {
        case .loadState:
            return FileManager.default.load(from: "appState.json", in: .applicationSupportDirectory)
                .decode(type: State.self, decoder: JSONDecoder())
                .replaceError(with: State())
                .flatMap { appState in
                    state.map { _ in
                        return .setState(appState)
                    }
                }
                .eraseToAnyPublisher()
        case let .save(appState):
            return Just(appState)
                .encode(encoder: JSONEncoder())
                .flatMap { FileManager.default.save(data: $0, to: "appState.json", in: .applicationSupportDirectory) }
                .flatMap {
                    state.map { _ in
                        return .none
                    }
                }
                .replaceError(with: .none)
                .eraseToAnyPublisher()
        }
    }
}
