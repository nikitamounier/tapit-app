//
//  TabButtonStyles.swift
//  Tap It
//
//  Created by Nikita Mounier on 09/02/2021.
//

import SwiftUI

struct TapTabButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.interactiveSpring())
    }
}

struct OtherTabButtonStyle: ButtonStyle {
    let tab: Tab
    let selectedTab: Tab
    
    func makeBody(configuration: Configuration) -> some View {
        if configuration.isPressed || selectedTab == tab {
            return Image(systemName: "\(tab.rawValue).fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding()
                .contentShape(Rectangle())
        } else {
            return Image(systemName: "\(tab.rawValue)")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding()
                .contentShape(Rectangle())
        }
    }
}
