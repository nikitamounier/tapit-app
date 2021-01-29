//
//  FacebookIcon.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//

import SwiftUI

// MARK: - Icon
struct FacebookIcon: View {
    let cornerRadiusScale: CGFloat
    
    init(cornerRadiusScale: CGFloat = 10 / 57) {
        self.cornerRadiusScale = cornerRadiusScale
    }
    
    var body: some View {
        FacebookShape(cornerRadiusScale: cornerRadiusScale)
            .scaledToFit()
    }
}

// MARK: - Shape
struct FacebookShape: Shape {
    let cornerRadiusScale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRect(CGRect(x: 0, y: 0.00958*height, width: width, height: 0.98039*height))
        path.move(to: CGPoint(x: 0.55886*width, y: 0.98997*height))
        path.addLine(to: CGPoint(x: 0.70876*width, y: 0.46243*height))
        path.addCurve(to: CGPoint(x: 0.6337*width, y: 0.29584*height), control1: CGPoint(x: 0.55886*width, y: 0.32505*height), control2: CGPoint(x: 0.571*width, y: 0.29584*height))
        path.addCurve(to: CGPoint(x: 0.59671*width, y: 0.15764*height), control1: CGPoint(x: 0.69933*width, y: 0.16167*height), control2: CGPoint(x: 0.6519*width, y: 0.15764*height))
        path.addCurve(to: CGPoint(x: 0.40261*width, y: 0.35322*height), control1: CGPoint(x: 0.48147*width, y: 0.15764*height), control2: CGPoint(x: 0.40261*width, y: 0.22657*height))
        path.closeSubpath()
        return path
    }
}

struct FacebookIcon_Previews: PreviewProvider {
    static var previews: some View {
        FacebookIcon()
    }
}
