//
//  SocialAndPresetsScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 05/04/2021.
//

import SwiftUI

struct SocialAndPresetsScreen: View {
    @Binding var currentCategory: TapScreen.TapCategories
    
    var body: some View {
        ZStack {
            TabView(selection: $currentCategory) {
                SocialsScreen()
                    .tag(TapScreen.TapCategories.socials)
                PresetsScreen()
                    .tag(TapScreen.TapCategories.presets)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct SocialAndPresetsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SocialAndPresetsScreen(currentCategory: .constant(.socials))
    }
}
