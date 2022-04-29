//
//  LocationsMapViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import MapKit
import CloudKit
import SwiftUI
import Purchases

extension LocationMapView {
    
    final class LocationMapViewModel:  NSObject, ObservableObject, CLLocationManagerDelegate {
        
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var isLoading = false
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
        
        
        @MainActor func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            
            withAnimation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
        
        @MainActor func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did Fail with Error")
        }
        
        @MainActor func getLocations(for locationManager: LocationManager) {
            showLoadingView()
            
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                    hideLoadingView()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                    hideLoadingView()
                }
            }
        }
        
        
        @MainActor func getCheckedInCount() {
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                } catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
        
        
        @MainActor func getAllAccessStatus(for purchasesManager: PurchasesManager) async {
            do {
                let purchaserInfo = try await Purchases.shared.purchaserInfo()
                if  ((purchaserInfo.entitlements[Entitlements.allaccess]?.isActive) == true) {
                    purchasesManager.hasAllAccess = true
                    print("Subscription Is Active 🟢")
                } else {
                    purchasesManager.hasAllAccess = false
                    print("Subscription is Not Active 🔴")
                }
            } catch {
                alertItem = AlertContext.unableToGetCheckInStatus
            }
        }
        
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
}
