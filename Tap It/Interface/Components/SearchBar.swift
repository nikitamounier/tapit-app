//
//  SearchBar.swift
//  Tap It
//
//  Created by Nikita Mounier on 12/02/2021.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var offset: CGFloat
    let onEditingChanged: (Bool) -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $text, onEditingChanged: onEditingChanged)
                    .foregroundColor(.gray)
                if !text.isEmpty {
                    Button(action: emptySearch) {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color.secondary)
                .frame(height: offset < 40 ? offset : 40)
        }
    }
    
    private func emptySearch() {
        text = ""
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""), offset: .constant(40), onEditingChanged: {_ in})
    }
}
