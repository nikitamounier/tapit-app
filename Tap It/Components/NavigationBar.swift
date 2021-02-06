//
//  NavigationBar.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

import SwiftUI

struct NavigationBar: View {
    let title: Text
    var overlineContent: AnyView?
    var underlineContent: AnyView?
    
    init(title: Text) {
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            title
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.leading)
            if let overlineContent = overlineContent {
                overlineContent
                    .padding(.leading)
            }
            if let underlineContent = underlineContent {
                Divider()
                underlineContent
                    .padding(.leading)
            }
        }
    }
}

extension NavigationBar: Buildable {
    func overline<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        mutating(keyPath: \.overlineContent, value: AnyView(content()))
    }
    
    func underline<Content: View>(@ViewBuilder content: () -> Content) -> Self {
        mutating(keyPath: \.underlineContent, value: AnyView(content()))
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
