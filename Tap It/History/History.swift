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
    
    @State private var selectedTab: Category = .all//temporary, will be in viewModel
    
    var historyLists: some View {
        TabView(selection: $selectedTab) {
            ForEach(Category.allCases, id: \.self) { category in
                HistoryList(category: category)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack(alignment: .topLeading) {
                    VStack(spacing: 0) {
                        HistoryNavigationBar(selectedTab: .constant(.all))
                            .padding(.top, geo.safeAreaInsets.top)
                            .hidden()
                        historyLists
                    }
                    HistoryNavigationBar(selectedTab: $selectedTab)
                        .padding(.top, geo.safeAreaInsets.top)
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
