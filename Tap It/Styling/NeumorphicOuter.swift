//
//  NeumorphicOuter.swift
//  Tap It
//
//  Created by Nikita Mounier on 27/01/2021.
//

import SwiftUI

extension View {
    /// Adds a neumorphic shadow around the view.
    /// - Parameters:
    ///   - dark: The dark shadow color on the bottom right.
    ///   - light: The light shadow color on the top left.
    ///   - offset: The offset of the shadow – how far up should the subject be.
    ///   - radius: How pronunced should be the shaodw.
    /// - Returns: A view with a nuemorphic shadow around it.
    func neumorphicOuter(dark: Color = Neumorphic.darkShadowColor, light: Color = Neumorphic.lightShadowColor, offset: CGFloat = 6, radius: CGFloat = 3) -> some View {
        modifier(NeumorphicOuter(dark: dark, light: light, offset: offset, radius: radius))
    }
}

private struct NeumorphicOuter: ViewModifier {
    var darkShadowColor: Color
    var lightShadowColor: Color
    var offset: CGFloat
    var radius: CGFloat
    
    init(dark: Color, light: Color, offset: CGFloat, radius: CGFloat) {
        self.darkShadowColor = dark
        self.lightShadowColor = light
        self.offset = offset
        self.radius = radius
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: darkShadowColor, radius: radius, x: offset, y: offset)
            .shadow(color: lightShadowColor, radius: radius, x: -(offset), y: -(offset))
    }
}
