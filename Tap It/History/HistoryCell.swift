//
//  HistoryCell.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

struct HistoryCell: View {
    let profilePicture: Image
    let name: String
    let socials: [String] // for now
    let date: String
    
    @ScaledMetric private var dynamicHeight: CGFloat = 120
    
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(Neumorphic.mainColor)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: dynamicHeight)
            .neumorphicOuter()
            .overlay(ProfilePreview(profilePicture: profilePicture, name: name, socials: socials, date: date))
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Neumorphic.mainColor
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(0..<100) { item in
                        HistoryCell(profilePicture: Image(systemName: "person.crop.square.fill"), name: "Nikita Mounier", socials: Array(repeating: "person.crop.square.fill", count: Int.random(in: 1...6)), date: "27/01")
                    }
                }
                .padding(.top)
                .frame(maxWidth: .infinity)
            }
            .environment(\.sizeCategory, .medium)
        }
    }
}
