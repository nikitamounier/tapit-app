//
//  MainView.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var tabModel = TabBarViewModel()
    
    init() {
        UITabBar.appearance().isHidden = true // hide default tab bar to make custom one
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                TabView(selection: $tabModel.selectedTab) { // just a tab controller without bar - still using it for its supposed caching abilities
                    History()
                        .tag(Tab.history)
                    Text("Tap view") // temporary, as still haven't made Tap view yet
                        .tag(Tab.tap)
                    Text("Profile view") // temporary, as still haven't made Profile view yet
                        .tag(Tab.profile)
                }
                TabBar(tabModel: tabModel, geo: geo)
                    .hidden() // dummy tab bar to make content go up
            }
            .overlay(TabBar(tabModel: tabModel, geo: geo), alignment: .bottom) // actual tab bar
            .ignoresSafeArea()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewDevice("iPhone 12")
    }
}
