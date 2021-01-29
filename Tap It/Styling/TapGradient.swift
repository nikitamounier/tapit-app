//
//  Color+Gradient.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

extension Color {
    static let tapGradientStart = Color(red: 32 / 255, green: 127 / 255, blue: 253 / 255)
    
    static let tapGgradientEnd = Color(red: 243 / 255, green: 0, blue: 246 / 255)
}

extension LinearGradient {
    enum GradientOptions {
        case topLeftToBottom
        case topLeftToBottomRight
        case topToBottom
        case leftToRight
        case rightToLeft
    }
    
    init(tapGradient: GradientOptions) {
        let colors: [Color] = [Color.tapGradientStart, Color.tapGgradientEnd]
        switch tapGradient {
        case .topLeftToBottom:
            self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottom)
        case .topLeftToBottomRight:
            self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .topToBottom:
            self.init(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
        case .leftToRight:
            self.init(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        case .rightToLeft:
            self.init(gradient: Gradient(colors: colors), startPoint: .trailing, endPoint: .leading)
        }
    }
}
