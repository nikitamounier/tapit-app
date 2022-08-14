import SwiftUI

struct Wobble: GeometryEffect {
  var condition: Bool
  var amount: CGFloat = 10
  var shakesPerUnit = 3
  var animatableData: CGFloat
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    ProjectionTransform(
      CGAffineTransform(
        translationX: condition ? amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)) : 0,
        y: 0
      )
    )
  }
}

extension View {
  func wobble(_ condition: Bool, amount: Int) -> some View {
    modifier(Wobble(condition: condition, animatableData: CGFloat(amount)))
  }
}
