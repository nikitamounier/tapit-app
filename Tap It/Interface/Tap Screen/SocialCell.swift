//
//  SocialCell.swift
//  Tap It
//
//  Created by Nikita Mounier on 12/03/2021.
//

import SwiftUI

struct SocialCell: View {
    let name: String
    @Binding var isSelected: Bool
    @State private var isSelectedTemp = false
    
    var content: some View {
        VStack {
            Image(name)
                .resizable()
                .scaledToFit()
                .scaleEffect(0.8)
                .padding([.horizontal, .top])
            Text(name)
                .padding(.bottom)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
    
    var stroke: some View {
        Group {
            if isSelectedTemp {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(LinearGradient(tapGradient: .topLeftToBottomRight), style: StrokeStyle(lineWidth: 3))
            }
        }
    }

    var body: some View {
        Button(action: { isSelectedTemp.toggle() }) {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Neumorphic.mainColor)
                .frame(maxWidth: .infinity, idealHeight: 135)
                .overlay(content)
                .overlay(stroke)
        }
        .padding()
        .neumorphicOuter()
    }
}

struct SocialCell_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            LazyVGrid(columns: .init(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 0) {
                ForEach(Image.SocialIcon.allCases, id: \.self) { social in
                    SocialCell(name: social.rawValue, isSelected: .constant(false))
                }
            }
        }
        .background(Neumorphic.backgroundColor)
        .ignoresSafeArea()
    }
}
