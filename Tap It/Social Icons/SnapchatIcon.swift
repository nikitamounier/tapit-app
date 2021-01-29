//
//  SnapchatIcon.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/01/2021.
//
// Thanks to Quassum Manus and his tool to convert SVG code to SwiftUI shapes: https://quassummanus.github.io/SVG-to-SwiftUI/

import SwiftUI

// MARK: - Icon
struct SnapchatIcon: View {
    let cornerRadiusScale: CGFloat
    
    init(cornerRadiusScale: CGFloat = 10 / 57) {
        self.cornerRadiusScale = cornerRadiusScale
    }
    
    var silhouette: some View {
        SnapchatSilhouette()
            .stroke(lineWidth: 20)
            .scale(0.7272)
    }
    
    var body: some View {
        SnapchatShape(cornerRadiusScale: cornerRadiusScale)
            .scaledToFit()
            .foregroundColor(.init(red: 255 / 255, green: 233 / 255, blue: 38 / 255))
            .overlay(silhouette)
    }
}

// MARK: - Shape
struct SnapchatShape: Shape {
    let cornerRadiusScale: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addRoundedRect(in: rect, cornerSize: CGSize(width: width  *  cornerRadiusScale, height: height  *  cornerRadiusScale), style: .circular)
        path.move(to: CGPoint(x: 0.76687 * width, y: 0.73764 * height))
        path.addCurve(to: CGPoint(x: 0.86476 * width, y: 0.68972 * height), control1: CGPoint(x: 0.79798 * width, y: 0.73268 * height), control2: CGPoint(x: 0.86295 * width, y: 0.72096 * height))
        path.addCurve(to: CGPoint(x: 0.85049 * width, y: 0.67174 * height), control1: CGPoint(x: 0.86527 * width, y: 0.68094 * height), control2: CGPoint(x: 0.85911 * width, y: 0.67313 * height))
        path.addCurve(to: CGPoint(x: 0.70332 * width, y: 0.52356 * height), control1: CGPoint(x: 0.75446 * width, y: 0.65567 * height), control2: CGPoint(x: 0.694 * width, y: 0.54558 * height))
        path.addCurve(to: CGPoint(x: 0.75329 * width, y: 0.4963 * height), control1: CGPoint(x: 0.71005 * width, y: 0.50764 * height), control2: CGPoint(x: 0.74006 * width, y: 0.50148 * height))
        path.addCurve(to: CGPoint(x: 0.75192 * width, y: 0.42779 * height), control1: CGPoint(x: 0.81661 * width, y: 0.47103 * height), control2: CGPoint(x: 0.78932 * width, y: 0.42779 * height))
        path.addCurve(to: CGPoint(x: 0.69666 * width, y: 0.43742 * height), control1: CGPoint(x: 0.73508 * width, y: 0.42779 * height), control2: CGPoint(x: 0.71509 * width, y: 0.44598 * height))
        path.addCurve(to: CGPoint(x: 0.64375 * width, y: 0.20645 * height), control1: CGPoint(x: 0.70237 * width, y: 0.34061 * height), control2: CGPoint(x: 0.71252 * width, y: 0.27241 * height))
        path.addCurve(to: CGPoint(x: 0.31155 * width, y: 0.27136 * height), control1: CGPoint(x: 0.55448 * width, y: 0.12097 * height), control2: CGPoint(x: 0.37335 * width, y: 0.13092 * height))
        path.addCurve(to: CGPoint(x: 0.30318 * width, y: 0.43742 * height), control1: CGPoint(x: 0.29318 * width, y: 0.31303 * height), control2: CGPoint(x: 0.30023 * width, y: 0.38919 * height))
        path.addCurve(to: CGPoint(x: 0.25873 * width, y: 0.43085 * height), control1: CGPoint(x: 0.29017 * width, y: 0.4432 * height), control2: CGPoint(x: 0.27158 * width, y: 0.43698 * height))
        path.addCurve(to: CGPoint(x: 0.24665 * width, y: 0.49627 * height), control1: CGPoint(x: 0.22634 * width, y: 0.4155 * height), control2: CGPoint(x: 0.17096 * width, y: 0.46595 * height))
        path.addCurve(to: CGPoint(x: 0.29315 * width, y: 0.54874 * height), control1: CGPoint(x: 0.27945 * width, y: 0.50932 * height), control2: CGPoint(x: 0.31047 * width, y: 0.51304 * height))
        path.addCurve(to: CGPoint(x: 0.25604 * width, y: 0.6073 * height), control1: CGPoint(x: 0.29128 * width, y: 0.55215 * height), control2: CGPoint(x: 0.28075 * width, y: 0.57818 * height))
        path.addCurve(to: CGPoint(x: 0.13695 * width, y: 0.69727 * height), control1: CGPoint(x: 0.18479 * width, y: 0.69136 * height), control2: CGPoint(x: 0.11988 * width, y: 0.65699 * height))
        path.addCurve(to: CGPoint(x: 0.23304 * width, y: 0.73764 * height), control1: CGPoint(x: 0.14777 * width, y: 0.72295 * height), control2: CGPoint(x: 0.20525 * width, y: 0.73321 * height))
        path.addCurve(to: CGPoint(x: 0.26118 * width, y: 0.78543 * height), control1: CGPoint(x: 0.24068 * width, y: 0.75214 * height), control2: CGPoint(x: 0.23513 * width, y: 0.78543 * height))
        path.addCurve(to: CGPoint(x: 0.34356 * width, y: 0.78101 * height), control1: CGPoint(x: 0.27517 * width, y: 0.78543 * height), control2: CGPoint(x: 0.30181 * width, y: 0.7739 * height))
        path.addCurve(to: CGPoint(x: 0.60521 * width, y: 0.80792 * height), control1: CGPoint(x: 0.39984 * width, y: 0.79055 * height), control2: CGPoint(x: 0.46376 * width, y: 0.90907 * height))
        path.addLine(to: CGPoint(x: 0.60524 * width, y: 0.80786 * height))
        path.addCurve(to: CGPoint(x: 0.72198 * width, y: 0.78287 * height), control1: CGPoint(x: 0.63572 * width, y: 0.78606 * height), control2: CGPoint(x: 0.65714 * width, y: 0.76992 * height))
        path.addCurve(to: CGPoint(x: 0.76687 * width, y: 0.73764 * height), control1: CGPoint(x: 0.76899 * width, y: 0.79209 * height), control2: CGPoint(x: 0.75592 * width, y: 0.75921 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.49824 * width, y: 0.86336 * height))
        path.addCurve(to: CGPoint(x: 0.49554 * width, y: 0.86355 * height), control1: CGPoint(x: 0.49878 * width, y: 0.86345 * height), control2: CGPoint(x: 0.49719 * width, y: 0.86355 * height))
        path.addCurve(to: CGPoint(x: 0.3855 * width, y: 0.82068 * height), control1: CGPoint(x: 0.44529 * width, y: 0.86355 * height), control2: CGPoint(x: 0.41214 * width, y: 0.83979 * height))
        path.addCurve(to: CGPoint(x: 0.22086 * width, y: 0.75163 * height), control1: CGPoint(x: 0.28814 * width, y: 0.75087 * height), control2: CGPoint(x: 0.24433 * width, y: 0.85685 * height))
        path.addCurve(to: CGPoint(x: 0.14694 * width, y: 0.65611 * height), control1: CGPoint(x: 0.08629 * width, y: 0.72784 * height), control2: CGPoint(x: 0.11271 * width, y: 0.66176 * height))
        path.addCurve(to: CGPoint(x: 0.24398 * width, y: 0.59713 * height), control1: CGPoint(x: 0.18637 * width, y: 0.64947 * height), control2: CGPoint(x: 0.21857 * width, y: 0.62708 * height))
        path.addCurve(to: CGPoint(x: 0.28202 * width, y: 0.52963 * height), control1: CGPoint(x: 0.26064 * width, y: 0.57752 * height), control2: CGPoint(x: 0.285 * width, y: 0.53664 * height))
        path.addCurve(to: CGPoint(x: 0.24081 * width, y: 0.51096 * height), control1: CGPoint(x: 0.27885 * width, y: 0.52205 * height), control2: CGPoint(x: 0.2501 * width, y: 0.51469 * height))
        path.addCurve(to: CGPoint(x: 0.26552 * width, y: 0.41657 * height), control1: CGPoint(x: 0.1451 * width, y: 0.47255 * height), control2: CGPoint(x: 0.21321 * width, y: 0.3919 * height))
        path.addCurve(to: CGPoint(x: 0.28646 * width, y: 0.42356 * height), control1: CGPoint(x: 0.27469 * width, y: 0.42097 * height), control2: CGPoint(x: 0.28154 * width, y: 0.42283 * height))
        path.addCurve(to: CGPoint(x: 0.29705 * width, y: 0.26501 * height), control1: CGPoint(x: 0.28354 * width, y: 0.37614 * height), control2: CGPoint(x: 0.27853 * width, y: 0.30703 * height))
        path.addCurve(to: CGPoint(x: 0.70291 * width, y: 0.26505 * height), control1: CGPoint(x: 0.3722 * width, y: 0.094 * height), control2: CGPoint(x: 0.62741 * width, y: 0.09295 * height))
        path.addCurve(to: CGPoint(x: 0.71348 * width, y: 0.42289 * height), control1: CGPoint(x: 0.7215 * width, y: 0.30718 * height), control2: CGPoint(x: 0.71639 * width, y: 0.37614 * height))
        path.addCurve(to: CGPoint(x: 0.77391 * width, y: 0.41626 * height), control1: CGPoint(x: 0.72899 * width, y: 0.41904 * height), control2: CGPoint(x: 0.74631 * width, y: 0.40489 * height))
        path.addCurve(to: CGPoint(x: 0.74745 * width, y: 0.515 * height), control1: CGPoint(x: 0.81705 * width, y: 0.43189 * height), control2: CGPoint(x: 0.82777 * width, y: 0.48989 * height))
        path.addCurve(to: CGPoint(x: 0.71801 * width, y: 0.52969 * height), control1: CGPoint(x: 0.74015 * width, y: 0.51737 * height), control2: CGPoint(x: 0.72055 * width, y: 0.52366 * height))
        path.addCurve(to: CGPoint(x: 0.85318 * width, y: 0.65617 * height), control1: CGPoint(x: 0.7143 * width, y: 0.53854 * height), control2: CGPoint(x: 0.76391 * width, y: 0.64126 * height))
        path.addCurve(to: CGPoint(x: 0.88065 * width, y: 0.69066 * height), control1: CGPoint(x: 0.8698 * width, y: 0.65892 * height), control2: CGPoint(x: 0.88164 * width, y: 0.67373 * height))
        path.addCurve(to: CGPoint(x: 0.77921 * width, y: 0.75163 * height), control1: CGPoint(x: 0.87837 * width, y: 0.73078 * height), control2: CGPoint(x: 0.8193 * width, y: 0.74452 * height))
        path.addCurve(to: CGPoint(x: 0.73968 * width, y: 0.80075 * height), control1: CGPoint(x: 0.77334 * width, y: 0.77807 * height), control2: CGPoint(x: 0.76899 * width, y: 0.80075 * height))
        path.addCurve(to: CGPoint(x: 0.61457 * width, y: 0.82078 * height), control1: CGPoint(x: 0.68956 * width, y: 0.79781 * height), control2: CGPoint(x: 0.67366 * width, y: 0.77838 * height))
        path.addCurve(to: CGPoint(x: 0.49824 * width, y: 0.86336 * height), control1: CGPoint(x: 0.57961 * width, y: 0.84567 * height), control2: CGPoint(x: 0.54522 * width, y: 0.86629 * height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.59293 * width, y: 0.79727 * height))
        path.addCurve(to: CGPoint(x: 0.73962 * width, y: 0.76913 * height), control1: CGPoint(x: 0.66472 * width, y: 0.74588 * height), control2: CGPoint(x: 0.6822 * width, y: 0.76499 * height))
        path.addCurve(to: CGPoint(x: 0.75636 * width, y: 0.72333 * height), control1: CGPoint(x: 0.7465 * width, y: 0.76913 * height), control2: CGPoint(x: 0.74158 * width, y: 0.75735 * height))
        path.addCurve(to: CGPoint(x: 0.84833 * width, y: 0.6912 * height), control1: CGPoint(x: 0.76893 * width, y: 0.72083 * height), control2: CGPoint(x: 0.83995 * width, y: 0.71088 * height))
        path.addLine(to: CGPoint(x: 0.84785 * width, y: 0.68735 * height))
        path.addCurve(to: CGPoint(x: 0.69254 * width, y: 0.55566 * height), control1: CGPoint(x: 0.74101 * width, y: 0.66947 * height), control2: CGPoint(x: 0.69447 * width, y: 0.5603 * height))
        path.addCurve(to: CGPoint(x: 0.77093 * width, y: 0.46772 * height), control1: CGPoint(x: 0.66085 * width, y: 0.49071 * height), control2: CGPoint(x: 0.74828 * width, y: 0.49125 * height))
        path.addCurve(to: CGPoint(x: 0.76236 * width, y: 0.44567 * height), control1: CGPoint(x: 0.78013 * width, y: 0.45811 * height), control2: CGPoint(x: 0.77353 * width, y: 0.44971 * height))
        path.addCurve(to: CGPoint(x: 0.70745 * width, y: 0.45543 * height), control1: CGPoint(x: 0.74339 * width, y: 0.43783 * height), control2: CGPoint(x: 0.73705 * width, y: 0.45407 * height))
        path.addCurve(to: CGPoint(x: 0.68017 * width, y: 0.44718 * height), control1: CGPoint(x: 0.69232 * width, y: 0.45476 * height), control2: CGPoint(x: 0.68883 * width, y: 0.45066 * height))
        path.addCurve(to: CGPoint(x: 0.63274 * width, y: 0.21782 * height), control1: CGPoint(x: 0.68721 * width, y: 0.34872 * height), control2: CGPoint(x: 0.69692 * width, y: 0.27939 * height))
        path.addCurve(to: CGPoint(x: 0.32611 * width, y: 0.27768 * height), control1: CGPoint(x: 0.55172 * width, y: 0.14024 * height), control2: CGPoint(x: 0.3835 * width, y: 0.14703 * height))
        path.addCurve(to: CGPoint(x: 0.31974 * width, y: 0.4474 * height), control1: CGPoint(x: 0.30882 * width, y: 0.31685 * height), control2: CGPoint(x: 0.31656 * width, y: 0.39614 * height))
        path.addCurve(to: CGPoint(x: 0.25188 * width, y: 0.44507 * height), control1: CGPoint(x: 0.31361 * width, y: 0.44857 * height), control2: CGPoint(x: 0.29645 * width, y: 0.46645 * height))
        path.addCurve(to: CGPoint(x: 0.25258 * width, y: 0.48161 * height), control1: CGPoint(x: 0.23967 * width, y: 0.43929 * height), control2: CGPoint(x: 0.19694 * width, y: 0.45925 * height))
        path.addCurve(to: CGPoint(x: 0.31127 * width, y: 0.51747 * height), control1: CGPoint(x: 0.26755 * width, y: 0.48758 * height), control2: CGPoint(x: 0.30143 * width, y: 0.49397 * height))
        path.addCurve(to: CGPoint(x: 0.15211 * width, y: 0.68725 * height), control1: CGPoint(x: 0.32637 * width, y: 0.55367 * height), control2: CGPoint(x: 0.25293 * width, y: 0.67039 * height))
        path.addLine(to: CGPoint(x: 0.15157 * width, y: 0.6912 * height))
        path.addCurve(to: CGPoint(x: 0.24338 * width, y: 0.72326 * height), control1: CGPoint(x: 0.16052 * width, y: 0.71243 * height), control2: CGPoint(x: 0.24021 * width, y: 0.72228 * height))
        path.addCurve(to: CGPoint(x: 0.25683 * width, y: 0.76654 * height), control1: CGPoint(x: 0.2581 * width, y: 0.75855 * height), control2: CGPoint(x: 0.24858 * width, y: 0.73824 * height))
        path.addCurve(to: CGPoint(x: 0.34629 * width, y: 0.76543 * height), control1: CGPoint(x: 0.26019 * width, y: 0.77791 * height), control2: CGPoint(x: 0.28833 * width, y: 0.75539 * height))
        path.addCurve(to: CGPoint(x: 0.59293 * width, y: 0.79727 * height), control1: CGPoint(x: 0.40685 * width, y: 0.7757 * height), control2: CGPoint(x: 0.46614 * width, y: 0.88771 * height))
        path.closeSubpath()
        return path
    }
}

// MARK: - Silhouette Outline
private struct SnapchatSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.85114 * width, y: 0.83005 * height))
        path.addCurve(to: CGPoint(x: 0.97995 * width, y: 0.7635 * height), control1: CGPoint(x: 0.89208 * width, y: 0.82316 * height), control2: CGPoint(x: 0.97757 * width, y: 0.80689 * height))
        path.addCurve(to: CGPoint(x: 0.96117 * width, y: 0.73853 * height), control1: CGPoint(x: 0.98062 * width, y: 0.7513 * height), control2: CGPoint(x: 0.97252 * width, y: 0.74046 * height))
        path.addCurve(to: CGPoint(x: 0.76753 * width, y: 0.53273 * height), control1: CGPoint(x: 0.83482 * width, y: 0.7162 * height), control2: CGPoint(x: 0.75526 * width, y: 0.56331 * height))
        path.addCurve(to: CGPoint(x: 0.83327 * width, y: 0.49487 * height), control1: CGPoint(x: 0.77638 * width, y: 0.51062 * height), control2: CGPoint(x: 0.81587 * width, y: 0.50206 * height))
        path.addCurve(to: CGPoint(x: 0.83148 * width, y: 0.39971 * height), control1: CGPoint(x: 0.91659 * width, y: 0.45977 * height), control2: CGPoint(x: 0.88069 * width, y: 0.39971 * height))
        path.addCurve(to: CGPoint(x: 0.75877 * width, y: 0.41309 * height), control1: CGPoint(x: 0.80931 * width, y: 0.39971 * height), control2: CGPoint(x: 0.78302 * width, y: 0.42498 * height))
        path.addCurve(to: CGPoint(x: 0.68914 * width, y: 0.09229 * height), control1: CGPoint(x: 0.76628 * width, y: 0.27862 * height), control2: CGPoint(x: 0.77964 * width, y: 0.1839 * height))
        path.addCurve(to: CGPoint(x: 0.25204 * width, y: 0.18245 * height), control1: CGPoint(x: 0.57169 * width, y: -0.02643 * height), control2: CGPoint(x: 0.33335 * width, y: -0.01261 * height))
        path.addCurve(to: CGPoint(x: 0.24102 * width, y: 0.41309 * height), control1: CGPoint(x: 0.22787 * width, y: 0.24032 * height), control2: CGPoint(x: 0.23714 * width, y: 0.34609 * height))
        path.addCurve(to: CGPoint(x: 0.18254 * width, y: 0.40396 * height), control1: CGPoint(x: 0.22391 * width, y: 0.42112 * height), control2: CGPoint(x: 0.19945 * width, y: 0.41247 * height))
        path.addCurve(to: CGPoint(x: 0.16664 * width, y: 0.49482 * height), control1: CGPoint(x: 0.13993 * width, y: 0.38264 * height), control2: CGPoint(x: 0.06705 * width, y: 0.4527 * height))
        path.addCurve(to: CGPoint(x: 0.22783 * width, y: 0.56769 * height), control1: CGPoint(x: 0.2098 * width, y: 0.51294 * height), control2: CGPoint(x: 0.25062 * width, y: 0.51812 * height))
        path.addCurve(to: CGPoint(x: 0.179 * width, y: 0.64903 * height), control1: CGPoint(x: 0.22537 * width, y: 0.57243 * height), control2: CGPoint(x: 0.21151 * width, y: 0.60858 * height))
        path.addCurve(to: CGPoint(x: 0.0223 * width, y: 0.77398 * height), control1: CGPoint(x: 0.08525 * width, y: 0.76578 * height), control2: CGPoint(x: -0.00015 * width, y: 0.71804 * height))
        path.addCurve(to: CGPoint(x: 0.14873 * width, y: 0.83005 * height), control1: CGPoint(x: 0.03654 * width, y: 0.80965 * height), control2: CGPoint(x: 0.11217 * width, y: 0.82391 * height))
        path.addCurve(to: CGPoint(x: 0.18576 * width, y: 0.89643 * height), control1: CGPoint(x: 0.15879 * width, y: 0.85019 * height), control2: CGPoint(x: 0.15149 * width, y: 0.89643 * height))
        path.addCurve(to: CGPoint(x: 0.29416 * width, y: 0.89029 * height), control1: CGPoint(x: 0.20417 * width, y: 0.89643 * height), control2: CGPoint(x: 0.23923 * width, y: 0.88042 * height))
        path.addCurve(to: CGPoint(x: 0.63843 * width, y: 0.92767 * height), control1: CGPoint(x: 0.36821 * width, y: 0.90354 * height), control2: CGPoint(x: 0.45231 * width, y: 1.06815 * height))
        path.addLine(to: CGPoint(x: 0.63847 * width, y: 0.92758 * height))
        path.addCurve(to: CGPoint(x: 0.79208 * width, y: 0.89288 * height), control1: CGPoint(x: 0.67858 * width, y: 0.89731 * height), control2: CGPoint(x: 0.70676 * width, y: 0.87489 * height))
        path.addCurve(to: CGPoint(x: 0.85114 * width, y: 0.83005 * height), control1: CGPoint(x: 0.85393 * width, y: 0.90569 * height), control2: CGPoint(x: 0.83674 * width, y: 0.86002 * height))
        path.closeSubpath()
        return path
    }
}

struct SnapchatIcon_Previews: PreviewProvider {
    static var previews: some View {
        SnapchatIcon()
    }
}
