//
//  TabView.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tab
    @State private var isPressingTab: [Tab: Bool] = [.history: false, .profile: false]
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    var tapLogo: some View {
        Image(systemName: "hand.raised.fill") // temporary until I make my own logo
            .resizable()
            .scaledToFit()
            .padding()
            .foregroundColor(.white)
    }
    
    var tapButton: some View {
        Button {
            generator.impactOccurred()
            switchTab(to: .tap)
        } label: {
            Circle()
                .fill(LinearGradient(tapGradient: .topLeftToBottom))
                .scaledToFit()
                .frame(width: 60, height: 60)
                .overlay(tapLogo)
        }
        .buttonStyle(TapTabButtonStyle())
        .offset(y: -20)
    }
    
    func otherTabButton(for tab: Tab) -> some View {
        Button(action: { switchTab(to: tab) }) {
            Image(systemName: selectedTab == tab || (isPressingTab[tab] ?? false) ? "\(tab.rawValue).fill" : tab.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .padding()
                .contentShape(Rectangle())
        }
        .buttonStyle(IsPressedButtonStyle(isPressed: tabBinding(for: tab)))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                otherTabButton(for: .history)
                    .frame(maxWidth: .infinity)
                otherTabButton(for: .history)
                    .frame(maxWidth: .infinity)
                    .hidden() // dummy tab button to make the other two space out without needing a Spacer who's width is dictated by a GeometryReader
                otherTabButton(for: .profile)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .overlay(tapButton)
        }
        .padding(.bottom, bottomPadding)
        .background(Neumorphic.mainColor)
        .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: -15)
    }
    
    private func switchTab(to tab: Tab) {
        selectedTab = tab
    }
    
    private func tabBinding(for tab: Tab) -> Binding<Bool> {
        return Binding(get: { (isPressingTab[tab] ?? false) }, set: { isPressingTab[tab] = $0 })
    }
    
    private var bottomPadding: CGFloat {
        if let inset = UIApplication.shared.windows.first?.safeAreaInsets.bottom {
            return inset - 7
        } else {
            return 0
        }
    }
}

//struct TabView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
