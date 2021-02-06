//
//  TabHeader.swift
//  Tap It
//
//  Created by Nikita Mounier on 06/02/2021.
//

import SwiftUI

struct TabHeader<Tabs>: View where Tabs: RandomAccessCollection, Tabs.Element: Hashable {
    private  let tabs: Tabs
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
            }
        }
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
                .matchedGeometryEffect(id: "capsule", in: animation)
                .animation(.linear(duration: 0.1))
        } else {
            Capsule()
                .frame(width: 20, height: 2)
                .foregroundColor(.blue)
                .hidden()
        }
    }
}

struct TabHeader_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
