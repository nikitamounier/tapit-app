//
//  Color+Gradient.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI

extension Color {
    static let gradientStart = Color(red: 32 / 255, green: 127 / 255, blue: 253 / 255)
    
    static let gradientEnd = Color(red: 243 / 255, green: 0, blue: 246 / 255)
    
    static let tapGradient = LinearGradient(gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]), startPoint: .topLeading, endPoint: .bottomTrailing)
}
