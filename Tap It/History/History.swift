//
//  History.swift
//  Tap It
//
//  Created by Nikita Mounier on 30/01/2021.
//

import SwiftUI

struct History: View {
    
    struct Category: Hashable, Equatable { // temporary - until I've made my Core Data models
        var name: String
    }
    let categories: [Category] = [.init(name: "All"), .init(name: "Favourites"), .init(name: "Friends"), .init(name: "Work"), .init(name: "Golf"), .init(name: "Wine Tasting")] // mock categories - would come from Core Data
    
    @State private var currentCategory: Category // temporary, will be in viewModel
    
    init() {
        _currentCategory = State(wrappedValue: categories[0])
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar(title: Text("History")) // dummy nav bar to make TabView go down
                        .underline {
                            TabHeader(categories, selection: .constant(categories[0]), name: \.name) // no need for it to update every time since dummy
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        .hidden()
                    
                    TabView(selection: $currentCategory) {
                        ForEach(categories, id: \.self) { category in
                            HistoryList(category: category)
                                .tag(category)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                }
                .overlay(
                    NavigationBar(title: Text("History")) // actual visible nav bar
                        .underline {
                            TabHeader(categories, selection: $currentCategory, name: \.name)
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                        .background(Neumorphic.mainColor)
                        .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: 6)
                    , alignment: .topLeading) // I'm sorry for this terrible formatting
                .background(Neumorphic.backgroundColor)
                .navigationBarHidden(true)
                .ignoresSafeArea()
            }
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
            .environment(\.sizeCategory, .medium)
            .previewDevice("iPhone 12")
            .preferredColorScheme(.light)
        
    }
}
