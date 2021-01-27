//
//  ContentView.swift
//  Tap It
//
//  Created by Nikita Mounier on 26/01/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<100) { item in
                    HistoryCell(profilePicture: Image(systemName: "person.crop.square.fill"), name: "Nikita Mounier", socials: Array(repeating: "person.crop.square.fill", count: Int.random(in: 1...6)), date: "27/01/2020")
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
