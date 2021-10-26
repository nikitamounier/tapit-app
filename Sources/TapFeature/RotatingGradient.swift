import SwiftUI

struct RotatingGradient<Content: InsettableShape>: View {
    let content: Content
    let showBorder: Bool
    @State private var gradientDegrees: Double = 0
    
    var body: some View {
        content
            .strokeBorder(gradient)
            .onChange(of: showBorder) { showingBorder in
                if showingBorder {
                    withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                        self.gradientDegrees = 360
                    }
                }
            }
    }
    
    var gradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(
                colors: showBorder ? [Color(red: 32 / 255, green: 127 / 255, blue: 253 / 255), Color(red: 243 / 255, green: 0, blue: 246 / 255)] : [Color.primary]
            ),
            center: .center,
            angle: .degrees(gradientDegrees)
        )
    }
}

extension InsettableShape {
    func rotatingGradientBorder(showBorder: Bool) -> some View {
        return RotatingGradient(content: self, showBorder: showBorder)
    }
}
