//
//  HistoryNavBar.swift
//  Tap It
//
//  Created by Nikita Mounier on 01/02/2021.
//

import SwiftUI

struct HistoryNavigationBar: View {
    @Binding var selectedTab: History.Category
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("History")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            Divider()
            categoriesNames
                .padding(.leading)
        }
    }
    
    var categoriesNames: some View {
        HStack(spacing: 20) {
            ForEach(History.Category.allCases, id: \.self) { category in
                VStack(alignment: .leading, spacing: 5) {
                    Text(category.rawValue.capitalized)
                        .foregroundColor(selectedTab == category ? .blue : .gray)
                        .onTapGesture { } // Go to said tab - right now capsule bugs if switching quickly, will do nothing for now
                    if selectedTab == category {
                        Capsule()
                            .frame(width: 20, height: 2)
                            .foregroundColor(.blue)
                            .matchedGeometryEffect(id: "capsule", in: animation, properties: .position)
                            .animation(.linear(duration: 0.05))
                    } else {
                        Capsule()
                            .frame(width: 20, height: 2)
                            .hidden()
                    }
                }
            }
        }
    }
}
