//
//  HistoryList.swift
//  Tap It
//
//  Created by Nikita Mounier on 01/02/2021.
//

import SwiftUI

struct HistoryList: View {
    let category: History.Category
    @Binding var scrollOffset: CGFloat
    
    var body: some View {
        OffsetScrollView(yOffset: $scrollOffset) {
            LazyVStack(spacing: 14) {
                ForEach(0..<100) { item in
                    HistoryCell(profilePicture: UIImage(systemName: "person.crop.square.fill") ?? .init(), name: "Nikita Mounier", socials: [], date: "27/01")
                }
            }
            .padding(.vertical, 14)
        }
    }
}
