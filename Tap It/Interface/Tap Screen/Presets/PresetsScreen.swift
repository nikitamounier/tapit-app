//
//  PresetsScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 05/04/2021.
//

import SwiftUI

struct PresetsScreen: View {
    var body: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: GridItem(.flexible()), count: 2), spacing: 5) {
                ForEach(Image.SocialIcon.allCases, id: \.self) { social in
                    SocialCell(name: social.rawValue, isSelected: .constant(false))
                }
            }
            .padding(.vertical, 14)
        }
    }
}
