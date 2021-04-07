//
//  ScreenController.swift
//  Tap It
//
//  Created by Nikita Mounier on 07/04/2021.
//

import SwiftUI

struct ScreenController<NavBarContent: View, MainContent: View>: View {
    let title: Text
    let navigationBarContent: NavBarContent
    let mainContent: MainContent
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar(title: title) {
                        navigationBarContent
                    }
                    .padding(.top, geo.safeAreaInsets.top)
                    .hidden()
                    
                    mainContent
                }
                .overlay(
                    NavigationBar(title: title) {
                        navigationBarContent
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

struct ScreenController_Previews: PreviewProvider {
    static var previews: some View {
        ScreenController(title: Text("Preview"), navigationBarContent: Text("This is a preview"), mainContent: Text("This is the main content of the preview"))
    }
}
