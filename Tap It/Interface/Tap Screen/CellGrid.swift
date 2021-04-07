//
//  CellGrid.swift
//  Tap It
//
//  Created by Nikita Mounier on 05/04/2021.
//

import SwiftUI

struct CellScreen<Data>: View where Data: RandomAccessCollection, Data.Element == String {
    let data: Data

    var body: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: GridItem(.flexible()), count: 2), spacing: 5) {
                ForEach(data, id: \.self) { element in
                    SocialCell(name: element, isSelected: .constant(false))
                }
            }
            .padding(.vertical, 14)
        }
    }
}
