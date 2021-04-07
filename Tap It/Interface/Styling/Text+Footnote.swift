//
//  Text+Footnote.swift
//  Tap It
//
//  Created by Nikita Mounier on 12/03/2021.
//

import SwiftUI

extension Text {
    /// Sets the text's font to `.footnote`, its font weight to `.thin`, and its foreground color to `.gray`.
    func footnoteStyle() -> Text {
        return self
            .font(.footnote)
            .fontWeight(.thin)
            .foregroundColor(.gray)
    }
}
