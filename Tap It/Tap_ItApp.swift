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
        var store: Store! // Since will be injected on initialisation of app – for performance, so as to not have to unwrap it when launching and terminating
        
        func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            store.dispatch(raw: .loadState)
            return true
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            store.dispatch(raw: .saveState)
        }
    }
}

