//
//  TabBarViewModel.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI
import Combine

enum Tab: String {
    case history = "rectangle.stack.person.crop"
    case tap = "" // since using custom iamge in the future
    case profile = "person.crop.circle"
}

class TabBarViewModel: ObservableObject {
    
    @Published var selectedTab: Tab = .history
    
    private let generator = UIImpactFeedbackGenerator(style: .light)
    
    func switchTab(to tab: Tab) {
        switch tab {
        case .tap:
            generator.impactOccurred()
            fallthrough
        default:
            selectedTab = tab
        }
    }
    
//    func currentlySelectingTab(_ tab: Tab) {
//        
//    }
}
