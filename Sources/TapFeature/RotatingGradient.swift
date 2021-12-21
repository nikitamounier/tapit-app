import Styleguide
import SwiftUI

struct RotatingGradient<Content: InsettableShape>: View, Animatable {
    let content: Content
    let showBorder: Bool
    var gradientDegrees: Double
    
    var animatableData: Double {
        get { gradientDegrees }
        set { gradientDegrees = newValue }
    }
    
    var body: some View {
        content
            .strokeBorder(
                showBorder ?
                    AngularGradient(
                        gradient: Gradient(colors: [.tapBlue, .tapPurple, .tapBlue]),
                        center: .center,
                        angle: .degrees(gradientDegrees)
                    ) :
                    AngularGradient(colors: [], center: .center, angle: .degrees(gradientDegrees)),
                lineWidth: 2.5
            )
    }
}

extension InsettableShape {
    func rotatingGradientBorder(showBorder: Bool, degrees: Double) -> some View {
        return RotatingGradient(content: self, showBorder: showBorder, gradientDegrees: degrees)
    }
}
