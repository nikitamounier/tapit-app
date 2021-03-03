//
//  NavigationBar.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

import SwiftUI

struct NavigationBar<Content: View>: View {
    let title: Text
    let undertitleContent: AnyView
    
    init(title: Text, @ViewBuilder undertitle: () -> Content = { EmptyView() as! Content }) {
        self.title = title
        self.undertitleContent = AnyView(undertitle())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            title
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            if let content = undertitleContent {
                content
                    .padding([])
            }
        }
    }
}
struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
