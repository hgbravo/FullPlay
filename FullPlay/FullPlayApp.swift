//
//  FullPlayApp.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/1/22.
//

import SwiftUI
import Purchases

@main
struct FullPlayApp: App {
    let locationManager = LocationManager()
    let storeManager    = StoreManager()
    
    init() {
        
        // Initialize Revenue Cat
        setupRevenueCat()
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(locationManager)
                .environmentObject(storeManager)
                .onAppear {
                    storeManager.getAllAccessStatus()
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
    
    
    func setupRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_tuRdNLwHNpUyuUaNXevurnHJdUL")
    }
}
