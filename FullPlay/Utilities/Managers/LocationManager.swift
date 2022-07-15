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
    
    let deviceLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        deviceLocationManager.delegate = self
        deviceLocationManager.startUpdatingLocation()
    }
    
    
    func requiereAlwaysLocationPermession() {
        deviceLocationManager.requestAlwaysAuthorization()
    }
    
    
    @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
    }
    
    @MainActor func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did Fail with Error")
    }
    
    
}
