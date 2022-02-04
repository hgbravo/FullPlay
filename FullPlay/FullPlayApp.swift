//
//  FullPlayApp.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/1/22.
//

import SwiftUI

@main
struct FullPlayApp: App {
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(locationManager)
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
