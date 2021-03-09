//
//  TabHeader.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

import SwiftUI

private struct TabCapsuleXPositionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = nextValue()
    }
}

struct TabHeader<Tabs, Location>: View where Tabs: RandomAccessCollection, Tabs.Element: Hashable, Location: Hashable {
    let location: Location
    private let tabs: Tabs
    private var tabNames: [Tabs.Element: String] = [:]
    
    @Binding var currentTab: Tabs.Element
    
    private let animation: Namespace.ID
    
    init(_ tabs: Tabs, selection: Binding<Tabs.Element>, name: KeyPath<Tabs.Element, String>, namespace: Namespace.ID, in location: Location) {
        self.tabs = tabs
        self._currentTab = selection
        var tmp: [Tabs.Element: String] = [:]
        tabs.forEach { tab in
            tmp.updateValue(tab[keyPath: name], forKey: tab)
        }
        self.tabNames = tmp // relating each tab to its name using the power of KeyPaths
        self.animation = namespace
        self.location = location
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: { setTab(to: tab) }) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(tabNames[tab] ?? "")
                                    .foregroundColor(currentTab == tab ? .blue : .gray)
                                TabCapsule(for: tab, current: currentTab, animation: animation, in: location)
                            }
                        }
                        .padding(.leading)
                        .id(tab)
                        .onPreferenceChange(TabCapsuleXPositionPreferenceKey.self) { scrollToTab(tab, position: $0, in: proxy) }
                        
                    }
                }
                .coordinateSpace(name: "capsuleBar\(location.hashValue)")
            }
        }
        .animation(.linear(duration: 0.1))
    }
    
    private func setTab(to tab: Tabs.Element) {
        withAnimation(.linear(duration: 0.1)) {
            currentTab = tab
        }
    }
    
    private func scrollToTab(_ tab: Tabs.Element, position: CGFloat?, in proxy: ScrollViewProxy) {
        if position != nil {
            withAnimation {
                proxy.scrollTo(tab)
            }
        }
    }
}
extension TabHeader {
    private struct TabCapsule<Tab: Equatable>: View {
        let tab: Tab
        let currentTab: Tab
        let animation: Namespace.ID
        let location: Location
        
        init(for tab: Tab, current: Tab, animation: Namespace.ID, in location: Location) {
            self.tab = tab
            self.currentTab = current
            self.animation = animation
            self.location = location
        }
        
        var positionReader: some View {
            GeometryReader { geo in
                let xPosition = geo.frame(in: .named("capsuleBar\(location.hashValue)")).origin.x
                Color.clear
                    .preference(key: TabCapsuleXPositionPreferenceKey.self, value: xPosition > geo.frame(in: .named("capsuleBar\(location.hashValue)")).width ? xPosition : nil)
            }
            .frame(width: 0, height: 0)
        }
        
        var body: some View {
            if currentTab == tab {
                Capsule()
                    .frame(width: 20, height: 2)
                    .foregroundColor(.blue)
                    .background(positionReader)
                    .matchedGeometryEffect(id: location, in: animation, isSource: currentTab == tab ? true : false)
            } else {
                Capsule()
                    .frame(width: 20, height: 2)
                    .hidden()
            }
        }
    }
}

struct TabHeader_Previews: PreviewProvider {
    static var previews: some View {
        TestHeader()
    }
}

private struct TestHeader: View {
    private enum TestEnum: String, CaseIterable {
        case socials = "Socials"
        case presets = "Presets"
    }
    
    private struct TabCategory: Hashable {
        var name: String
    }
    private let userConfiguratedCategories: [TabCategory] = [.init(name: "Dog"), .init(name: "Cat"), .init(name: "Lizard"), .init(name: "Iguana")]
    
    @State private var currentEnumSelection: TestEnum = .socials
    @State private var currentStructSelection: TabCategory
    @Namespace private var animation
    
    init() {
        _currentStructSelection = State(initialValue: userConfiguratedCategories[0])
    }
    
    var body: some View {
        VStack {
            TabHeader(TestEnum.allCases, selection: $currentEnumSelection, name: \.rawValue, namespace: animation, in: "test")
            TabHeader(userConfiguratedCategories, selection: $currentStructSelection, name: \.name, namespace: animation, in: "test")
        }
    }
}
