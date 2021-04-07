//
//  ProfilePreview.swift
//  Tap It
//
//  Created by Nikita Mounier on 07/04/2021.
//

import SwiftUI

struct ProfilePreview<ProfileIcon: View, TopContent: View, BottomContent: View>: View {
    let profileIcon: ProfileIcon
    let topContent: TopContent
    let bottomContent: (GeometryProxy) -> BottomContent
    
    init(profileIcon: ProfileIcon, topContent: TopContent, @ViewBuilder bottomContent: @escaping (GeometryProxy) -> BottomContent) {
        self.profileIcon = profileIcon
        self.topContent = topContent
        self.bottomContent = bottomContent
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                profileIcon
                    .frame(width: geo.size.width / 6, height: geo.size.width / 6)
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    topContent
                    Divider()
                    bottomContent(geo)
                }
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

//struct ProfilePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePreview()
//    }
//}
