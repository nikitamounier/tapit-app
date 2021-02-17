//
//  TwitterIcon.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//
// Thanks to Quassum Manus and his tool to convert SVG code to SwiftUI shapes: https://quassummanus.github.io/SVG-to-SwiftUI/

import SwiftUI

// MARK: - Icon
struct TwitterIcon: View {
    let cornerRadiusScale: CGFloat
    
    init(cornerRadiusScale: CGFloat = 10 / 57) {
        self.cornerRadiusScale = cornerRadiusScale
    }
    
    var body: some View {
        TwitterShape(cornerRadiusScale: cornerRadiusScale)
            .fill(Color(red: 3 / 255, green: 169 / 255, blue: 244 / 255))
            .scaledToFit()
            
    }
}

// MARK: - Shape
struct TwitterShape: Shape {
    let cornerRadiusScale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: width * cornerRadiusScale, height: height * cornerRadiusScale), style: .circular)
        path.move(to: CGPoint(x: 0.82378 * width, y: 0.29917 * height))
        path.addCurve(to: CGPoint(x: 0.74727 * width, y: 0.32015 * height), control1: CGPoint(x: 0.79942 * width, y: 0.30981 * height), control2: CGPoint(x: 0.77365 * width, y: 0.31687 * height))
        path.addCurve(to: CGPoint(x: 0.80569 * width, y: 0.24673 * height), control1: CGPoint(x: 0.77508 * width, y: 0.30366 * height), control2: CGPoint(x: 0.79587 * width, y: 0.27754 * height))
        path.addCurve(to: CGPoint(x: 0.72148 * width, y: 0.2789 * height), control1: CGPoint(x: 0.77966 * width, y: 0.26218 * height), control2: CGPoint(x: 0.75118 * width, y: 0.27306 * height))
        path.addCurve(to: CGPoint(x: 0.65365 * width, y: 0.24005 * height), control1: CGPoint(x: 0.70328 * width, y: 0.25944 * height), control2: CGPoint(x: 0.67964 * width, y: 0.2459 * height))
        path.addCurve(to: CGPoint(x: 0.57571 * width, y: 0.24611 * height), control1: CGPoint(x: 0.62765 * width, y: 0.23421 * height), control2: CGPoint(x: 0.60049 * width, y: 0.23631 * height))
        path.addCurve(to: CGPoint(x: 0.51469 * width, y: 0.29497 * height), control1: CGPoint(x: 0.55093 * width, y: 0.2559 * height), control2: CGPoint(x: 0.52967 * width, y: 0.27293 * height))
        path.addCurve(to: CGPoint(x: 0.49174 * width, y: 0.36969 * height), control1: CGPoint(x: 0.49972 * width, y: 0.31701 * height), control2: CGPoint(x: 0.49172 * width, y: 0.34305 * height))
        path.addCurve(to: CGPoint(x: 0.49484 * width, y: 0.39996 * height), control1: CGPoint(x: 0.49165 * width, y: 0.37986 * height), control2: CGPoint(x: 0.49269 * width, y: 0.39001 * height))
        path.addCurve(to: CGPoint(x: 0.34314 * width, y: 0.35972 * height), control1: CGPoint(x: 0.442 * width, y: 0.39736 * height), control2: CGPoint(x: 0.39032 * width, y: 0.38365 * height))
        path.addCurve(to: CGPoint(x: 0.22109 * width, y: 0.26107 * height), control1: CGPoint(x: 0.29597 * width, y: 0.33579 * height), control2: CGPoint(x: 0.25438 * width, y: 0.30217 * height))
        path.addCurve(to: CGPoint(x: 0.20626 * width, y: 0.358 * height), control1: CGPoint(x: 0.20397 * width, y: 0.29031 * height), control2: CGPoint(x: 0.19867 * width, y: 0.32498 * height))
        path.addCurve(to: CGPoint(x: 0.26194 * width, y: 0.43871 * height), control1: CGPoint(x: 0.21386 * width, y: 0.39101 * height), control2: CGPoint(x: 0.23377 * width, y: 0.41988 * height))
        path.addCurve(to: CGPoint(x: 0.20194 * width, y: 0.42232 * height), control1: CGPoint(x: 0.24092 * width, y: 0.43814 * height), control2: CGPoint(x: 0.22034 * width, y: 0.43252 * height))
        path.addCurve(to: CGPoint(x: 0.23198 * width, y: 0.50786 * height), control1: CGPoint(x: 0.202 * width, y: 0.45442 * height), control2: CGPoint(x: 0.21261 * width, y: 0.48411 * height))
        path.addCurve(to: CGPoint(x: 0.30832 * width, y: 0.55417 * height), control1: CGPoint(x: 0.25135 * width, y: 0.5316 * height), control2: CGPoint(x: 0.27831 * width, y: 0.54796 * height))
        path.addCurve(to: CGPoint(x: 0.27352 * width, y: 0.55851 * height), control1: CGPoint(x: 0.29697 * width, y: 0.55715 * height), control2: CGPoint(x: 0.28526 * width, y: 0.55861 * height))
        path.addCurve(to: CGPoint(x: 0.24832 * width, y: 0.55627 * height), control1: CGPoint(x: 0.26506 * width, y: 0.55866 * height), control2: CGPoint(x: 0.25662 * width, y: 0.55792 * height))
        path.addCurve(to: CGPoint(x: 0.2957 * width, y: 0.62224 * height), control1: CGPoint(x: 0.25692 * width, y: 0.58263 * height), control2: CGPoint(x: 0.27347 * width, y: 0.60567 * height))
        path.addCurve(to: CGPoint(x: 0.37247 * width, y: 0.64877 * height), control1: CGPoint(x: 0.31794 * width, y: 0.6388 * height), control2: CGPoint(x: 0.34475 * width, y: 0.64807 * height))
        path.addCurve(to: CGPoint(x: 0.20799 * width, y: 0.70542 * height), control1: CGPoint(x: 0.3255 * width, y: 0.68548 * height), control2: CGPoint(x: 0.2676 * width, y: 0.70542 * height))
        path.addCurve(to: CGPoint(x: 0.17622 * width, y: 0.70357 * height), control1: CGPoint(x: 0.19737 * width, y: 0.70551 * height), control2: CGPoint(x: 0.18676 * width, y: 0.70489 * height))
        path.addCurve(to: CGPoint(x: 0.38016 * width, y: 0.76318 * height), control1: CGPoint(x: 0.237 * width, y: 0.74276 * height), control2: CGPoint(x: 0.30785 * width, y: 0.76347 * height))
        path.addCurve(to: CGPoint(x: 0.75819 * width, y: 0.38529 * height), control1: CGPoint(x: 0.62457 * width, y: 0.76318 * height), control2: CGPoint(x: 0.75819 * width, y: 0.56075 * height))
        path.addCurve(to: CGPoint(x: 0.75773 * width, y: 0.36811 * height), control1: CGPoint(x: 0.75819 * width, y: 0.37943 * height), control2: CGPoint(x: 0.75819 * width, y: 0.37377 * height))
        path.addCurve(to: CGPoint(x: 0.82378 * width, y: 0.29917 * height), control1: CGPoint(x: 0.78375 * width, y: 0.34933 * height), control2: CGPoint(x: 0.80614 * width, y: 0.32597 * height))
        path.closeSubpath()
        return path
    }
}

struct TwitterIcon_Previews: PreviewProvider {
    static var previews: some View {
        TwitterIcon()
    }
}
