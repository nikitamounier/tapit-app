//
//  Tap_ItApp.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

@main
struct Tap_ItApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let store = Redux.store
    
    init() {
        appDelegate.store = store
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}

extension Tap_ItApp {
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var store: Store?
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            guard let store = store else { return true }
            store.dispatch(raw: .loadState)
            return true
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            guard let store = store else { return }
            store.dispatch(raw: .save(store.state))
            
        }
    }
}
