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
    @StateObject var purchasesManager = PurchasesManager()
    
    init() {
        
        // Initialize Revenue Cat
        setupRevenueCat()
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(locationManager)
                .environmentObject(purchasesManager)
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
    
    
    func setupRevenueCat() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_tuRdNLwHNpUyuUaNXevurnHJdUL")
    }
}
