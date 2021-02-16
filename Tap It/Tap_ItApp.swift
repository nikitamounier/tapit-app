//
//  Tap_ItApp.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

@main
struct Tap_ItApp: App {
    let store = Redux.store
    
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background: // where would dispatch 'background' raw action, aka save state to FileManager
                break
            case .inactive:
                break
            case .active: // where would dispatch 'active' raw action, aka load state from disk if not already loaded
                break
            @unknown default:
                break
            }
        }
    }
}
