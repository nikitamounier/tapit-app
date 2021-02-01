//
//  ProfilePreview.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//

import SwiftUI

struct ProfilePreview: View {
    let profilePicture: UIImage
    let name: String
    let socials: [String] // for now
    let date: String
    
    let numberOfIcons = Int.random(in: 1...4)
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                
                Image(uiImage: profilePicture)
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
                    switch numberOfIcons { // to test ui without building whole model, since can't store views in an array
                    case 1:
                        InstagramIcon(cornerRadiusScale: 0.3)
                    case 2:
                        SnapchatIcon(cornerRadiusScale: 0.3)
                        PhoneIcon(cornerRadiusScale: 0.3)
                    case 3:
                        PhoneIcon(cornerRadiusScale: 0.3)
                        TwitterIcon(cornerRadiusScale: 0.3)
                        InstagramIcon(cornerRadiusScale: 0.3)
                    case 4:
                        InstagramIcon(cornerRadiusScale: 0.3)
                        SnapchatIcon(cornerRadiusScale: 0.3)
                        TwitterIcon(cornerRadiusScale: 0.3)
                        PhoneIcon(cornerRadiusScale: 0.3)
                    default:
                        InstagramIcon(cornerRadiusScale: 0.3)
                    }
                    Spacer()
                }
                LinearGradient(tapGradient: .leftToRight)
                    .mask(Image(systemName: "ellipsis").font(.title))
                    .frame(width: geo.size.width / 10, height: geo.size.height / 10)
                    .padding(.trailing)
            }
            .frame(height: geo.size.height / 3.5)
        }
    }
}

//struct ProfilePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePreview()
//    }
//}
