//
//  InstagramIcon.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//
// Thanks to Quassum Manus and his tool to convert SVG code to SwiftUI shapes: https://quassummanus.github.io/SVG-to-SwiftUI/

import SwiftUI

// MARK: - Icon
struct InstagramIcon: View {
    let cornerRadiusScale: CGFloat
    
    init(cornerRadiusScale: CGFloat = 10 / 57) {
        self.cornerRadiusScale = cornerRadiusScale
    }
    
    var body: some View {
        InstagramShape(cornerRadiusScale: cornerRadiusScale)
            .fill(instagramGradient) // temporary - until I find true gradient
            .scaledToFit()
        
    }
    
    private let instagramGradient: LinearGradient = {
        let color1 = Color(red: 255 / 255, green: 221 / 255, blue: 85 / 255)
        let color2 = Color(red: 255 / 255, green: 84 / 255, blue: 62 / 255)
        let color3 = Color(red: 200 / 255, green: 55 / 255, blue: 171 / 255)
        let gradient = Gradient(colors: [color1, color2, color3])
        return LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing)
    }()
}

// MARK: - Shape
struct InstagramShape: Shape {
    let cornerRadiusScale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: width  *  cornerRadiusScale, height: height  *  cornerRadiusScale), style: .circular)
        path.move(to: CGPoint(x: 0.50001 * width, y: 0.13183 * height))
        path.addCurve(to: CGPoint(x: 0.15125 * width, y: 0.25882 * height), control1: CGPoint(x: 0.34918 * width, y: 0.13183 * height), control2: CGPoint(x: 0.20595 * width, y: 0.11841 * height))
        path.addCurve(to: CGPoint(x: 0.13193 * width, y: 0.49995 * height), control1: CGPoint(x: 0.12865 * width, y: 0.3168 * height), control2: CGPoint(x: 0.13193 * width, y: 0.39211 * height))
        path.addCurve(to: CGPoint(x: 0.15125 * width, y: 0.74104 * height), control1: CGPoint(x: 0.13193 * width, y: 0.59457 * height), control2: CGPoint(x: 0.1289 * width, y: 0.68351 * height))
        path.addCurve(to: CGPoint(x: 0.49992 * width, y: 0.86806 * height), control1: CGPoint(x: 0.20583 * width, y: 0.88152 * height), control2: CGPoint(x: 0.35022 * width, y: 0.86806 * height))
        path.addCurve(to: CGPoint(x: 0.84864 * width, y: 0.74104 * height), control1: CGPoint(x: 0.64436 * width, y: 0.86806 * height), control2: CGPoint(x: 0.79327 * width, y: 0.8831 * height))
        path.addCurve(to: CGPoint(x: 0.86796 * width, y: 0.49995 * height), control1: CGPoint(x: 0.87128 * width, y: 0.68247 * height), control2: CGPoint(x: 0.86796 * width, y: 0.60828 * height))
        path.addCurve(to: CGPoint(x: 0.80615 * width, y: 0.1936 * height), control1: CGPoint(x: 0.86796 * width, y: 0.35614 * height), control2: CGPoint(x: 0.87589 * width, y: 0.2633 * height))
        path.addCurve(to: CGPoint(x: 0.49984 * width, y: 0.13183 * height), control1: CGPoint(x: 0.73553 * width, y: 0.12298 * height), control2: CGPoint(x: 0.64004 * width, y: 0.13183 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.46703 * width, y: 0.19817 * height))
        path.addCurve(to: CGPoint(x: 0.79959 * width, y: 0.64857 * height), control1: CGPoint(x: 0.78164 * width, y: 0.19767 * height), control2: CGPoint(x: 0.82168 * width, y: 0.16269 * height))
        path.addCurve(to: CGPoint(x: 0.50005 * width, y: 0.80156 * height), control1: CGPoint(x: 0.79173 * width, y: 0.82042 * height), control2: CGPoint(x: 0.66089 * width, y: 0.80156 * height))
        path.addCurve(to: CGPoint(x: 0.19835 * width, y: 0.49978 * height), control1: CGPoint(x: 0.20679 * width, y: 0.80156 * height), control2: CGPoint(x: 0.19835 * width, y: 0.79317 * height))
        path.addCurve(to: CGPoint(x: 0.46703 * width, y: 0.19809 * height), control1: CGPoint(x: 0.19835 * width, y: 0.20299 * height), control2: CGPoint(x: 0.22161 * width, y: 0.19833 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.69649 * width, y: 0.25927 * height))
        path.addCurve(to: CGPoint(x: 0.65233 * width, y: 0.30343 * height), control1: CGPoint(x: 0.6721 * width, y: 0.25927 * height), control2: CGPoint(x: 0.65233 * width, y: 0.27904 * height))
        path.addCurve(to: CGPoint(x: 0.69649 * width, y: 0.34758 * height), control1: CGPoint(x: 0.65233 * width, y: 0.32781 * height), control2: CGPoint(x: 0.6721 * width, y: 0.34758 * height))
        path.addCurve(to: CGPoint(x: 0.74064 * width, y: 0.30343 * height), control1: CGPoint(x: 0.72087 * width, y: 0.34758 * height), control2: CGPoint(x: 0.74064 * width, y: 0.32781 * height))
        path.addCurve(to: CGPoint(x: 0.69649 * width, y: 0.25927 * height), control1: CGPoint(x: 0.74064 * width, y: 0.27904 * height), control2: CGPoint(x: 0.72087 * width, y: 0.25927 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.50001 * width, y: 0.3109 * height))
        path.addCurve(to: CGPoint(x: 0.31101 * width, y: 0.49995 * height), control1: CGPoint(x: 0.39562 * width, y: 0.3109 * height), control2: CGPoint(x: 0.31101 * width, y: 0.39556 * height))
        path.addCurve(to: CGPoint(x: 0.50001 * width, y: 0.68895 * height), control1: CGPoint(x: 0.31101 * width, y: 0.60434 * height), control2: CGPoint(x: 0.39562 * width, y: 0.68895 * height))
        path.addCurve(to: CGPoint(x: 0.68897 * width, y: 0.49995 * height), control1: CGPoint(x: 0.60439 * width, y: 0.68895 * height), control2: CGPoint(x: 0.68897 * width, y: 0.60434 * height))
        path.addCurve(to: CGPoint(x: 0.50001 * width, y: 0.3109 * height), control1: CGPoint(x: 0.68897 * width, y: 0.39556 * height), control2: CGPoint(x: 0.60439 * width, y: 0.3109 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.50001 * width, y: 0.37724 * height))
        path.addCurve(to: CGPoint(x: 0.50001 * width, y: 0.62265 * height), control1: CGPoint(x: 0.66222 * width, y: 0.37724 * height), control2: CGPoint(x: 0.66242 * width, y: 0.62265 * height))
        path.addCurve(to: CGPoint(x: 0.50001 * width, y: 0.37724 * height), control1: CGPoint(x: 0.33784 * width, y: 0.62265 * height), control2: CGPoint(x: 0.33759 * width, y: 0.37724 * height))
        path.closeSubpath()
        return path
    }
}

struct InstagramIcon_Previews: PreviewProvider {
    static var previews: some View {
        InstagramIcon()
    }
}
