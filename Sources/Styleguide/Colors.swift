import SwiftUI

import enum SharedModels.Social

public extension Color {
  init(_ fromTrait: (UITraitCollection) -> Self) {
    self = fromTrait(UITraitCollection.current)
  }
  
  static let tapBlue = Color(red: 32 / 255, green: 127 / 255, blue: 253 / 255)
  static let tapPurple = Color(red: 243 / 255, green: 0, blue: 246 / 255)
  
  static let tertiary = Color(uiColor: .tertiarySystemGroupedBackground)
}

public extension Gradient {
  static let tapGradient = Self(colors: [.tapBlue, .tapPurple])
}

public extension ShapeStyle where Self == LinearGradient {
  static func tapGradient(startPoint: UnitPoint = .leading, endPoint: UnitPoint = .trailing) -> Self {
    return Self(colors: [.tapBlue, .tapPurple], startPoint: startPoint, endPoint: endPoint)
  }
}

public extension Color {
  init(social: Social) {
    switch social {
    case .instagram:
      self = .pink
    case .snapchat:
      self = .yellow
    case .twitter:
      self = .cyan
    case .facebook:
      self = .blue
    case .reddit:
      self = .orange
    case .tikTok:
      self = .black
    case .weChat:
      self = .green
    case .github:
      self = .gray
    case .linkedIn:
      self = .blue
    case .address:
      self = .green
    case .email:
      self = .cyan
//    case .phone:
//      self = .green
    }
  }
}
