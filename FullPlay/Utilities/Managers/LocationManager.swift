//
//  LocationManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import Foundation
import MapKit
import SwiftUI

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locations: [FPLocation] = []
    @Published var currentLocation: CLLocation?
    
    var selectedLocation: FPLocation?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    let deviceLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        deviceLocationManager.delegate = self
        deviceLocationManager.startUpdatingLocation()
    }
    
    
    func requestAlwaysLocationPermession() {
        deviceLocationManager.requestAlwaysAuthorization()
    }
    
    
    @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    @MainActor func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did Fail with Error")
    }
    
    
}
