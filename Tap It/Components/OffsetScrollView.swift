//
//  ScrollView.swift
//  Tap It
//
//  Created by Nikita Mounier on 12/02/2021.
//

import SwiftUI

// Thanks to swiftwithmajid's article for this - https://swiftwithmajid.com/2020/09/24/mastering-scrollview-in-swiftui/

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

/// ScrollView with onOffsetChanged callback
struct OffsetScrollView<Content: View>: View {
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let offsetChanged: (CGPoint) -> Void
    private let content: Content
    
    private var offset: Binding<CGFloat>?
    @State private var privateOffset: CGFloat = .zero
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        yOffset: Binding<CGFloat>,
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(axes: axes, showsIndicators: showsIndicators, offset: .some(yOffset), onOffsetChanged: onOffsetChanged, content: content)
    }
    
    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(axes: axes, showsIndicators: showsIndicators, offset: nil, onOffsetChanged: onOffsetChanged, content: content)
    }
    
    private init(
        axes: Axis.Set,
        showsIndicators: Bool,
        offset: Binding<CGFloat>?,
        onOffsetChanged: @escaping (CGPoint) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offset = offset
        self.offsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        ScrollView(axes: axes, showsIndicators: showsIndicators, offset: offset ?? $privateOffset, offsetChanged: offsetChanged, content: content)
    }
}

extension OffsetScrollView {
    private struct ScrollView: View {
        let axes: Axis.Set
        let showsIndicators: Bool
        @Binding var offset: CGFloat
        let offsetChanged: (CGPoint) -> Void
        let content: Content
        
        var body: some View {
            SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
                VStack(spacing: 0) { // so that GeometryReader doesn't take extra space
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).origin)
                    }
                    .frame(width: 0, height: 0)
                    content
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { point in
                offset = point.y
                offsetChanged(point)
            }
        }
    }
}
