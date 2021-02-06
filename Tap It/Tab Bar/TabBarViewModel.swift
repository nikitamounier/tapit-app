//
//  TabBarViewModel.swift
//  Tap It
//
//  Created by Nikita Mounier on 04/02/2021.
//

import SwiftUI
import Combine

enum Tab: CaseIterable {
    case history
    case tap
    case profile
}

class TabBarViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
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
}
