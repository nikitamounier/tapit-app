//
//  ProfileScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 07/04/2021.
//

import SwiftUI

struct ProfileScreen: View {
    var body: some View {
        ScreenController(title: Text("Profile"), navigationBarContent: Text("ProfilePreview"), mainContent: Text("Profile content"))
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
