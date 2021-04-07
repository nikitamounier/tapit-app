//
//  SocialsScreen.swift
//  Tap It
//
//  Created by Nikita Mounier on 12/03/2021.
//

import SwiftUI

struct SocialsScreen: View {
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: GridItem(.flexible()), count: 2), spacing: 5) {
                ForEach(Image.SocialIcon.allCases, id: \.self) { social in
                    SocialCell(name: social.rawValue, isSelected: .constant(false))
                }
            }
            .padding(.vertical, 14)
        }
    }
}

//struct CellScreen<Data>: View where Data: RandomAccessCollection, Data.Element == String {
//    let data: Data
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: .init(repeating: GridItem(.flexible()), count: 2), spacing: 5) {
//                ForEach(data, id: \.self) { element in
//                    SocialCell(name: element)
//                }
//            }
//        }
//    }
//}

struct SocialsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SocialsScreen()
    }
}
