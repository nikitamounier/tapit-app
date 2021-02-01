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
            path.move(to: CGPoint(x: 0.98433*width, y: 0.98943*height))
            path.addCurve(to: CGPoint(x: 0.61108*width, y: 0.01707*height), control1: CGPoint(x: 0.9847*width, y: 0.21342*height), control2: CGPoint(x: 0.9266*width, y: 0.01707*height))
            path.addCurve(to: CGPoint(x: 0.31605*width, y: 0.17021*height), control1: CGPoint(x: 0.4594*width, y: 0.01707*height), control2: CGPoint(x: 0.3576*width, y: 0.09568*height))
            path.addCurve(to: CGPoint(x: 0.51098*width, y: 0.27647*height), control1: CGPoint(x: 0.32401*width, y: 0.39604*height), control2: CGPoint(x: 0.34883*width, y: 0.27647*height))
            path.addCurve(to: CGPoint(x: 0.67313*width, y: 0.52764*height), control1: CGPoint(x: 0.67075*width, y: 0.27647*height), control2: CGPoint(x: 0.67313*width, y: 0.41759*height))
            path.closeSubpath()
            return path
        }
}

struct FacebookIcon_Previews: PreviewProvider {
    static var previews: some View {
        FacebookIcon()
    }
}
