//
//  MainView.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var store: Store
    
    private var tabBinding: Binding<Tab> {
        store.binding(state: \.tabSelection.currentTab, actions: { .tabAction(.setTab(to: $0)) })
    }
    
    init() {
        UITabBar.appearance().isHidden = true // hide default tab bar to make custom one
    }
    
    var body: some View {
        ScrollView([]) { // So that tab bar doesn't move up with keyboard
            VStack(spacing: 0) {
                TabView(selection: tabBinding) { // just a tab controller without bar - still using it for its supposed caching abilities
                    History()
                        .tag(Tab.history)
                    Text("Tap view") // temporary, as still haven't made Tap view yet
                        .tag(Tab.tap)
                    Text("Profile view") // temporary, as still haven't made Profile view yet
                        .tag(Tab.profile)
                }
                TabBar(selectedTab: .constant(.history)) // no need for it to update since dummy
                    .hidden() // dummy tab bar to make content go up
            }
            .overlay(TabBar(selectedTab: tabBinding), alignment: .bottom) // actual tab bar
        }
        .ignoresSafeArea()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
