//
//  Neumorphism.swift
//  Tap It
//
//  Created by Nikita Mounier on 27/01/2021.
//

import SwiftUI

enum Neumorphic {
    private static let defaultMainColor = Color(red: 238 / 255, green: 240 / 255, blue: 243 / 255, opacity: 1.000)
    private static let defaultSecondaryColor = Color(red: 0.482, green: 0.502, blue: 0.549, opacity: 1.000)
    
    private static let defaultBackgroundColor = Color(red: 229 / 255, green: 229 / 255, blue: 229 / 255)
    
    private static let defaultLightShadowSolidColor = Color(red: 1.000, green: 1.000, blue: 1.000, opacity: 1.000)
    private static let defaultDarkShadowSolidColor = Color(red: 0.820, green: 0.851, blue: 0.902, opacity: 1.000)
    
    private static let defaultLightShadowColor = Color(red: 1.000, green: 1.000, blue: 1.000, opacity: 0.500)
    private static let defaultDarkShadowColor = Color(red: 0.66, green: 0.72, blue: 0.84, opacity: 0.55)
    
    static var mainColor: Color {
        return defaultMainColor
    }
    
    static var backgroundColor: Color {
        return defaultMainColor
    }
    
    static var secondaryColor: Color  {
        return defaultSecondaryColor
    }
    
    static var lightShadowColor: Color {
        return defaultLightShadowSolidColor
    }
    
    static var darkShadowColor: Color {
        return defaultDarkShadowSolidColor
    }
}
