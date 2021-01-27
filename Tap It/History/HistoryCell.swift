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
    
    var profile: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                profilePicture
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: geo.size.width / 6, height: geo.size.width / 6)
                    .padding(.horizontal)
                VStack(alignment: .leading) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(name)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text(date)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                            .font(.footnote)
                    }
                    Divider()
                    HStack(alignment: .center) {
                        HStack {
                            ForEach(socials.prefix(4), id: \.self) { app in
                                Image(systemName: app)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            }
                            Spacer()
                        }
                        Color.tapGradient
                            .mask(Image(systemName: "ellipsis").font(.title))
                            .frame(width: geo.size.width / 10)
                            .padding(.trailing)
                    }
                    .frame(height: geo.size.height / 3)
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width * 0.9, height: dynamicHeight)
            .shadow(radius: 5)
            .overlay(profile)
    }
}

struct HistoryCell_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<100) { item in
                    HistoryCell(profilePicture: Image(systemName: "person.crop.square.fill"), name: "Nikita Mounier", socials: Array(repeating: "person.crop.square.fill", count: Int.random(in: 1...6)), date: "27/01/2020")
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
        }
        .environment(\.sizeCategory, .medium)
    }
}
