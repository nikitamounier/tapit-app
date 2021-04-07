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
    
    let tempSocials = Image.SocialIcon.allCases
        .shuffled()
        .prefix(Int.random(in: 2...4))
    
    var profileIcon: some View {
        Image(uiImage: profilePicture)
            .resizable()
            .clipShape(Circle())
    }
    
    var topContent: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Text(name)
                .font(.headline)
            Spacer()
            (Text(Image(systemName: "calendar")) + Text(" \(date)"))
                .foregroundColor(.gray)
                .padding(.trailing)
                .font(.footnote)
        }
        .lineLimit(1)
    }
    
    func bottomContent(geo: GeometryProxy) -> some View {
        HStack(alignment: .center) {
            HStack {
                ForEach(tempSocials, id: \.rawValue) { social in
                    Button(action: {}) {
                        Image(social: social)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
            LinearGradient(tapGradient: .leftToRight)
                .mask(Image(systemName: "ellipsis").font(.title))
                .frame(width: geo.size.width / 10, height: geo.size.height / 10)
                .padding(.trailing)
        }
        .frame(height: geo.size.height / 3)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(Neumorphic.mainColor)
            .neumorphicOuter()
            .overlay(ProfilePreview(profileIcon: profileIcon, topContent: topContent, bottomContent: bottomContent))
            .frame(height: dynamicHeight)
            .padding(.horizontal)
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        HistoryCell(profilePicture: UIImage(systemName: "person.crop.square.fill") ?? .init(), name: "Nikita Mounier", socials: [], date: "30/01")
    }
}
