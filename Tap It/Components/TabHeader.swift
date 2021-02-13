//
//  TabHeader.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

import SwiftUI

struct TabHeader<Tabs>: View where Tabs: RandomAccessCollection, Tabs.Element: Hashable {
    private let tabs: Tabs
    private var tabNames: [Tabs.Element: String] = [:]
    
    @Binding var currentTab: Tabs.Element
    
    @Namespace private var animation
    
    init(_ tabs: Tabs, selection: Binding<Tabs.Element>, name: KeyPath<Tabs.Element, String>) {
        self.tabs = tabs
        self._currentTab = selection
        var tmp: [Tabs.Element: String] = [:]
        tabs.forEach { tab in
            tmp.updateValue(tab[keyPath: name], forKey: tab)
        }
        self.tabNames = tmp // relating each tab to its name using the power of KeyPaths
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(tabs, id: \.self) { tab in
                    VStack(alignment: .leading, spacing: 5) {
                        Button {
                            withAnimation {
                                currentTab = tab
                            }
                        } label: {
                            Text(tabNames[tab] ?? "")
                                .foregroundColor(currentTab == tab ? .blue : .gray)
                        }
                        TabCapsule(for: tab, current: currentTab, animation: animation)
                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .animation(.linear(duration: 0.1))
    }
}

private struct TabCapsule<Tab: Equatable>: View {
    let tab: Tab
    let currentTab: Tab
    let animation: Namespace.ID
    
    init(for tab: Tab, current: Tab, animation: Namespace.ID) {
        self.tab = tab
        self.currentTab = current
        self.animation = animation
    }
    
    var body: some View {
        if currentTab == tab {
            Capsule()
                .frame(width: 20, height: 2)
                .foregroundColor(.blue)
                .matchedGeometryEffect(id: Data.init(), in: animation, properties: .position)
        } else {
            Capsule()
                .frame(width: 20, height: 2)
                .hidden()
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
    
    init() {
        _currentStructSelection = State(initialValue: userConfiguratedCategories[0])
    }
    
    var body: some View {
        VStack {
            TabHeader(TestEnum.allCases, selection: $currentEnumSelection, name: \.rawValue)
            TabHeader(userConfiguratedCategories, selection: $currentStructSelection, name: \.name)
        }
    }
}
