//
//  ProfilePreview.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//

import SwiftUI

struct ProfilePreview: View {
    let profilePicture: Image
    let name: String
    let socials: [String] // for now
    let date: String
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                
                profilePicture
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: geo.size.width / 6, height: geo.size.width / 6)
                    .padding(.horizontal)
                
                profileDetails(in: geo)
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
    
    func profileDetails(in geo: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            
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
                    .frame(width: geo.size.width / 10, height: geo.size.height / 10)
                    .padding(.trailing)
            }
            .frame(height: geo.size.height / 4)
        }
    }
}

//struct ProfilePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePreview()
//    }
//}
