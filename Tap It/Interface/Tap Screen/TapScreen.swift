//
//  TapScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 28/02/2021.
//

import SwiftUI

struct TapScreen: View {
    
    enum TapCategories: String, CaseIterable {
        case socials = "Socials"
        case presets = "Presets"
    }
    
    @State private var currentCategory: TapCategories = .socials
    
    var tabView: some View {
        TabView(selection: $currentCategory) {
            //SocialsScreen()
            //PresetsScreen()
            Text("Socials")
                .tag(TapCategories.socials)
            Text("Presets")
                .tag(TapCategories.presets)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar(title: Text("Tap It")) {
                        TabHeader(TapCategories.allCases, selection: .constant(.socials), name: \.rawValue, in: "")
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                    .hidden()
                    
               tabView
                }
                .overlay(
                    NavigationBar(title: Text("Tap It")) {
                        TabHeader(TapCategories.allCases, selection: $currentCategory, name: \.rawValue, in: "tapScreen")
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                    .background(Neumorphic.mainColor)
                    .shadow(color: Color(white: 0, opacity: 0.15), radius: 15, y: 6),
                alignment: .topLeading
                )
                .background(Neumorphic.mainColor)
                .navigationBarHidden(true)
                .ignoresSafeArea()
            }
        }
    }
}

struct TapScreen_Previews: PreviewProvider {
    static var previews: some View {
        TapScreen()
    }
}
