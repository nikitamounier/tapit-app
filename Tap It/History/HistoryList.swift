//
//  HistoryList.swift
//  Tap It
//
//  Created by Nikita Mounier on 01/02/2021.
//

import SwiftUI

struct HistoryList: View {
    let category: History.Category
    @ScaledMetric private var dynamicTextFieldHeight: CGFloat = 40
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    LazyVStack(spacing: 15) {
                        ForEach(0..<100) { item in
                            HistoryCell(profilePicture: UIImage(systemName: "person.crop.square.fill") ?? .init(), name: "Nikita Mounier", socials: [], date: "27/01")
                        }
                    }
                    .id(0)
                    .padding(.top, 15)
                }
                .onAppear {
                    proxy.scrollTo(0, anchor: .top) // skip TextField, should only show up if user scroll up
                }
            }
        }
    }
}
