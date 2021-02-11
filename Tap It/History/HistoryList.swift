//
//  HistoryList.swift
//  Tap It
//
//  Created by Nikita Mounier on 01/02/2021.
//

import SwiftUI

struct HistoryList: View {
    let category: History.Category
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 13) {
                ForEach(0..<100) { item in
                    HistoryCell(profilePicture: UIImage(systemName: "person.crop.square.fill") ?? .init(), name: "Nikita Mounier", socials: [], date: "27/01")
                }
            }
            .padding(.top, 13)
        }
    }
}
