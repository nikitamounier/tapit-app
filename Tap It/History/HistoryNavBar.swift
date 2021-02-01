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
        VStack(alignment: .leading) {
            Text("History")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            Divider()
            categoriesRow
                .padding(.leading)
        }
    }
    
    var categoriesRow: some View {
        HStack(spacing: 20) {
            ForEach(History.Category.allCases, id: \.self) { category in
                VStack(alignment: .leading, spacing: 5) {
                    Button(action: { selectedTab = category }) {
                        Text(category.rawValue.capitalized)
                            .foregroundColor(selectedTab == category ? .blue : .gray)
                    }
                    Capsule()
                        .frame(width: 20, height: 2)
                        .foregroundColor(selectedTab == category ? .blue : .clear)
                }
            }
        }
    }
}
