//
//  History.swift
//  Tap It
//
//  Created by Nikita Mounier on 30/01/2021.
//

import SwiftUI
import SwiftUIX

struct History: View {
    
    enum Category: String, CaseIterable { // temporary
        case all, favourites, college, work
    }
    
    @State private var selectedTab: Category = .all // temporary, will be in viewModel
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0) {
                        HistoryNavigationBar(selectedTab: .constant(.all)) // dummy nav bar to make TabView go down
                            .padding(.top, geo.safeAreaInsets.top)
                            .hidden()
                        TabView(selection: $selectedTab) {
                            ForEach(Category.allCases, id: \.self) { category in
                                HistoryList(category: category)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                    HistoryNavigationBar(selectedTab: $selectedTab) // actual nav bar
                        .padding(.top, geo.safeAreaInsets.top)
                        .background(Neumorphic.mainColor)
                        .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: 6)
                }
                .navigationBarHidden(true)
                .background(Neumorphic.backgroundColor)
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
