//
//  History.swift
//  Tap It
//
//  Created by Nikita Mounier on 30/01/2021.
//

import SwiftUI

struct HistoryScreen: View {
    
    struct Category: Hashable, Equatable { // temporary - until I've made my Core Data models
        var name: String
    }
    let categories: [Category] = [.init(name: "All"), .init(name: "Favourites"), .init(name: "Friends"), .init(name: "Work"), .init(name: "Golf"), .init(name: "Wine Tasting"), .init(name: "Football"), .init(name: "Tennis")] // mock categories - would come from Core Data
    
    @State private var currentCategory: Category // temporary, will be in viewModel
    @State private var scrollOffset: CGFloat = .zero
    
    @Namespace private var historyAnimation
    
    init() {
        _currentCategory = State(initialValue: categories[0])
    }
    
    var tabView: some View {
        TabView(selection: $currentCategory) {
            ForEach(categories, id: \.self) { category in
                HistoryList(category: category, scrollOffset: $scrollOffset)
                    .tag(category)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    var navBarContent: some View {
        TabHeader(categories, selection: $currentCategory, name: \.name, namespace: historyAnimation, in: "historyScreen")
    }
    var body: some View {
        ScreenController(title: Text("History"), navigationBarContent: navBarContent, mainContent: tabView)
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        HistoryScreen()
            .environment(\.sizeCategory, .medium)
            .previewDevice("iPhone 12")
            .preferredColorScheme(.light)
        
    }
}
