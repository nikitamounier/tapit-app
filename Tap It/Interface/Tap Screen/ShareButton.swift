//
//  ShareButton.swift
//  Tap It
//
//  Created by Nikita Mounier on 05/04/2021.
//

import SwiftUI

struct ShareButton: View {
    let action: () -> Void
    
    var text: some View {
        Text("Share")
            .foregroundColor(.white)
            .font(.headline)
    }
    
    var body: some View {
        Button(action: action) {
            Capsule()
                .fill(LinearGradient(tapGradient: .leftToRight))
                .frame(height: 45)
                .overlay(text)
                .padding(.horizontal)
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(action: {})
    }
}
