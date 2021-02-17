//
//  PhoneIcon.swift
//  Tap It
//
//  Created by Nikita Mounier on 29/01/2021.
//
// Thanks to Quassum Manus and his tool to convert SVG code to SwiftUI shapes: https://quassummanus.github.io/SVG-to-SwiftUI/

import SwiftUI

// MARK: - Icon
struct PhoneIcon: View {
    let cornerRadiusScale: CGFloat
    
    init(cornerRadiusScale: CGFloat = 10 / 57) {
        self.cornerRadiusScale = cornerRadiusScale
    }
    
    var body: some View {
        PhoneShape(cornerRadiusScale: cornerRadiusScale)
            .fill(LinearGradient(tapGradient: .topLeftToBottom))
            .scaledToFit()
    }
}

// MARK: - Shape
struct PhoneShape: Shape {
    let cornerRadiusScale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: width  *  cornerRadiusScale, height: height  *  cornerRadiusScale), style: .circular)
        path.move(to: CGPoint(x: 0.71752 * width, y: 0.55973 * height))
        path.addCurve(to: CGPoint(x: 0.66912 * width, y: 0.53807 * height), control1: CGPoint(x: 0.70363 * width, y: 0.54561 * height), control2: CGPoint(x: 0.68688 * width, y: 0.53807 * height))
        path.addCurve(to: CGPoint(x: 0.62015 * width, y: 0.55959 * height), control1: CGPoint(x: 0.65151 * width, y: 0.53807 * height), control2: CGPoint(x: 0.63461 * width, y: 0.54547 * height))
        path.addLine(to: CGPoint(x: 0.5749 * width, y: 0.60361 * height))
        path.addCurve(to: CGPoint(x: 0.56387 * width, y: 0.59802 * height), control1: CGPoint(x: 0.57118 * width, y: 0.60166 * height), control2: CGPoint(x: 0.56745 * width, y: 0.59984 * height))
        path.addCurve(to: CGPoint(x: 0.5497 * width, y: 0.59062 * height), control1: CGPoint(x: 0.55872 * width, y: 0.59551 * height), control2: CGPoint(x: 0.55385 * width, y: 0.59313 * height))
        path.addCurve(to: CGPoint(x: 0.43185 * width, y: 0.4858 * height), control1: CGPoint(x: 0.50731 * width, y: 0.56434 * height), control2: CGPoint(x: 0.46879 * width, y: 0.5301 * height))
        path.addCurve(to: CGPoint(x: 0.39319 * width, y: 0.42626 * height), control1: CGPoint(x: 0.41395 * width, y: 0.46372 * height), control2: CGPoint(x: 0.40192 * width, y: 0.44513 * height))
        path.addCurve(to: CGPoint(x: 0.42641 * width, y: 0.39439 * height), control1: CGPoint(x: 0.40493 * width, y: 0.41578 * height), control2: CGPoint(x: 0.41581 * width, y: 0.40488 * height))
        path.addCurve(to: CGPoint(x: 0.43844 * width, y: 0.38251 * height), control1: CGPoint(x: 0.43042 * width, y: 0.39048 * height), control2: CGPoint(x: 0.43443 * width, y: 0.38643 * height))
        path.addCurve(to: CGPoint(x: 0.43844 * width, y: 0.2858 * height), control1: CGPoint(x: 0.46851 * width, y: 0.35316 * height), control2: CGPoint(x: 0.46851 * width, y: 0.31515 * height))
        path.addLine(to: CGPoint(x: 0.39935 * width, y: 0.24765 * height))
        path.addCurve(to: CGPoint(x: 0.38603 * width, y: 0.23437 * height), control1: CGPoint(x: 0.39491 * width, y: 0.24331 * height), control2: CGPoint(x: 0.39032 * width, y: 0.23884 * height))
        path.addCurve(to: CGPoint(x: 0.35911 * width, y: 0.20837 * height), control1: CGPoint(x: 0.37744 * width, y: 0.2257 * height), control2: CGPoint(x: 0.36842 * width, y: 0.21676 * height))
        path.addCurve(to: CGPoint(x: 0.31114 * width, y: 0.18783 * height), control1: CGPoint(x: 0.34522 * width, y: 0.19496 * height), control2: CGPoint(x: 0.32861 * width, y: 0.18783 * height))
        path.addCurve(to: CGPoint(x: 0.26245 * width, y: 0.20837 * height), control1: CGPoint(x: 0.29367 * width, y: 0.18783 * height), control2: CGPoint(x: 0.27677 * width, y: 0.19496 * height))
        path.addCurve(to: CGPoint(x: 0.26217 * width, y: 0.20865 * height), control1: CGPoint(x: 0.26231 * width, y: 0.20851 * height), control2: CGPoint(x: 0.26231 * width, y: 0.20851 * height))
        path.addLine(to: CGPoint(x: 0.21348 * width, y: 0.25659 * height))
        path.addCurve(to: CGPoint(x: 0.18241 * width, y: 0.32158 * height), control1: CGPoint(x: 0.19515 * width, y: 0.27448 * height), control2: CGPoint(x: 0.1847 * width, y: 0.29628 * height))
        path.addCurve(to: CGPoint(x: 0.20074 * width, y: 0.42528 * height), control1: CGPoint(x: 0.17897 * width, y: 0.36239 * height), control2: CGPoint(x: 0.19129 * width, y: 0.4004 * height))
        path.addCurve(to: CGPoint(x: 0.31028 * width, y: 0.60361 * height), control1: CGPoint(x: 0.22393 * width, y: 0.48636 * height), control2: CGPoint(x: 0.25859 * width, y: 0.54296 * height))
        path.addCurve(to: CGPoint(x: 0.53466 * width, y: 0.7751 * height), control1: CGPoint(x: 0.373 * width, y: 0.67671 * height), control2: CGPoint(x: 0.44846 * width, y: 0.73443 * height))
        path.addCurve(to: CGPoint(x: 0.66067 * width, y: 0.81144 * height), control1: CGPoint(x: 0.5676 * width, y: 0.79033 * height), control2: CGPoint(x: 0.61156 * width, y: 0.80836 * height))
        path.addCurve(to: CGPoint(x: 0.66969 * width, y: 0.81172 * height), control1: CGPoint(x: 0.66368 * width, y: 0.81158 * height), control2: CGPoint(x: 0.66683 * width, y: 0.81172 * height))
        path.addCurve(to: CGPoint(x: 0.75231 * width, y: 0.77705 * height), control1: CGPoint(x: 0.70277 * width, y: 0.81172 * height), control2: CGPoint(x: 0.73055 * width, y: 0.80012 * height))
        path.addCurve(to: CGPoint(x: 0.75289 * width, y: 0.77636 * height), control1: CGPoint(x: 0.75246 * width, y: 0.77678 * height), control2: CGPoint(x: 0.75274 * width, y: 0.77664 * height))
        path.addCurve(to: CGPoint(x: 0.77795 * width, y: 0.75106 * height), control1: CGPoint(x: 0.76033 * width, y: 0.76755 * height), control2: CGPoint(x: 0.76893 * width, y: 0.75959 * height))
        path.addCurve(to: CGPoint(x: 0.79656 * width, y: 0.73303 * height), control1: CGPoint(x: 0.7841 * width, y: 0.74533 * height), control2: CGPoint(x: 0.7904 * width, y: 0.73932 * height))
        path.addCurve(to: CGPoint(x: 0.81818 * width, y: 0.68467 * height), control1: CGPoint(x: 0.81074 * width, y: 0.71864 * height), control2: CGPoint(x: 0.81818 * width, y: 0.70186 * height))
        path.addCurve(to: CGPoint(x: 0.79613 * width, y: 0.63674 * height), control1: CGPoint(x: 0.81818 * width, y: 0.66735 * height), control2: CGPoint(x: 0.81059 * width, y: 0.65071 * height))
        path.addLine(to: CGPoint(x: 0.71752 * width, y: 0.55973 * height))
        path.closeSubpath()
        return path
    }
}

struct PhoneIcon_Previews: PreviewProvider {
    static var previews: some View {
        PhoneIcon()
    }
}
