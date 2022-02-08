//
//  LocationsMapViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView {
    
    @MainActor final class LocationMapViewModel:  NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var alertItem: AlertItem?
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.565017,
                                                                                  longitude: -81.589506),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.3,
                                                                          longitudeDelta: 0.3))
        
        let deviceLocationManager = CLLocationManager()
        
        override init() {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        
        func requiereAllowOnceLocationPermession() {
            deviceLocationManager.requestLocation()
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            
            withAnimation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did Fail with Error")
        }
        
        func getLocations(for locationManager: LocationManager) {
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
        
        func getCheckedInClount() {
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                } catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
    }
}
