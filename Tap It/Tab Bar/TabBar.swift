//
//  TabView.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var tabModel: TabBarViewModel
    let geo: GeometryProxy
    
    var tapLogo: some View {
        Image(systemName: "hand.raised.fill") // temporary until I make my own logo
            .resizable()
            .scaledToFit()
            .padding()
            .foregroundColor(.white)
    }
    
    var tapButton: some View {
        Button(action: { tabModel.switchTab(to: .tap) }) {
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
        Button(action: { tabModel.switchTab(to: tab) }) {
            EmptyView() // since it's buttonStyle which decides which view should be drawn
        }
        .buttonStyle(OtherTabButtonStyle(tab: tab, selectedTab: tabModel.selectedTab))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                otherTabButton(for: .history)
                    .frame(maxWidth: .infinity)
                otherTabButton(for: .history)
                    .frame(maxWidth: .infinity)
                    .hidden()
                otherTabButton(for: .profile)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .overlay(tapButton)
        }
        .padding(.bottom, geo.safeAreaInsets.bottom)
        .background(Neumorphic.mainColor)
        .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: -15)
    }
    
}

//struct TabView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar()
//    }
//}
