//
//  HistoryCell.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

struct HistoryCell: View {
    let profilePicture: UIImage
    let name: String
    let socials: [String] // for now
    let date: String
    
    @ScaledMetric private var dynamicHeight: CGFloat = 105
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(Neumorphic.mainColor)
            .frame(width: UIScreen.main.bounds.width  *  0.9, height: dynamicHeight)
            .neumorphicOuter()
            .overlay(ProfilePreview(profilePicture: profilePicture, name: name, socials: socials, date: date))
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCell(profilePicture: UIImage(systemName: "person.crop.square.fill") ?? .init(), name: "Nikita Mounier", socials: [], date: "30/01")
    }
}
