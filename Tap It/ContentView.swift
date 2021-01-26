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
        Text("Hello world!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
