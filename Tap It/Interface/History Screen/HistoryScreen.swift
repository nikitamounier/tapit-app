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
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar(title: Text("History")) {
                        TabHeader(categories, selection: .constant(categories[0]), name: \.name, namespace: historyAnimation, in: "_") // no need for it to update every time since dummy
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        .hidden()
                    
                    tabView
                }
                .overlay(
                    NavigationBar(title: Text("History")) { // Actual navigation bar
                        TabHeader(categories, selection: $currentCategory, name: \.name, namespace: historyAnimation, in: "historyScreen")
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        .background(Neumorphic.mainColor)
                        .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: 6),
                    alignment: .topLeading // I'm sorry for this terrible formatting
                )
                .background(Neumorphic.backgroundColor)
                .navigationBarHidden(true)
                .ignoresSafeArea()
            }
        }
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
