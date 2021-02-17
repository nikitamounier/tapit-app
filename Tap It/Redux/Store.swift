//
//  Store.swift
//  Tap It
//
//  Created by Nikita Mounier on 16/02/2021.
//

import Foundation
import Recombine

typealias Store = BaseStore<Redux.State, Redux.Action.Raw, Redux.Action.Refined>
typealias SubStore<SubState: Equatable, SubAction> = LensedStore<Redux.State, SubState, Redux.Action.Raw, Redux.Action.Refined, SubAction>

extension Redux {
    static let store = Store(state: .init(placeholder: ""), reducer: Reducer.main, middleware: middleware, publishOn: DispatchQueue.main)
}
