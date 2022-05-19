//
//  AppTabViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

extension AppTabView {
    
    final class AppTabViewModel: ObservableObject {
        
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }
        
        
        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView { hasSeenOnboardView = true }
        }
    }
}
