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

struct IsPressedButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .onChange(of: configuration.isPressed) { value in
                isPressed = value
            }
    }
}
