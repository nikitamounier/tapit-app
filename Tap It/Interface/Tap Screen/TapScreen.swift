//
//  TapScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/02/2021.
//

import SwiftUI

struct TapScreen: View {
    
    enum TapCategories: String, CaseIterable {
        case socials = "Socials"
        case presets = "Presets"
    }
    
    @State private var currentCategory: TapCategories = .socials
    @Namespace private var tapAnimation
    
    @State private var showShareButton = false
    
    var shareButton: some View {
        Group {
            if showShareButton {
                ShareButton(action: {})
                    .transition(.move(edge: .bottom))
                    .padding(.bottom)
                    .padding(.bottom)
                    .animation(.spring())
            }
        }
    }
    
    var navBarContent: some View {
        VStack(alignment: .leading) {
            Text("Select below, click share, and tap.")
                .footnoteStyle()
                .padding(.leading)
            TabHeader(TapCategories.allCases, selection: $currentCategory, name: \.rawValue, namespace: tapAnimation, in: "tapScreen")
        }
    }
    
    var mainContent: some View {
        SocialAndPresetsScreen(currentCategory: $currentCategory)
            .onTapGesture {
                showShareButton.toggle()
            }
    }
    
    var body: some View {
        ScreenController(title: Text("Tap It"), navigationBarContent: navBarContent, mainContent: mainContent)
    }
}

struct TapScreen_Previews: PreviewProvider {
    static var previews: some View {
        TapScreen()
    }
}
