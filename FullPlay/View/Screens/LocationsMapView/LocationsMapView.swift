//
//  LocationsMapView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Purchases

struct LocationMapView: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var purchasesManager: PurchasesManager
    @StateObject private var viewModel = LocationMapViewModel()
    
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    FPAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0], allAccess: purchasesManager.hasAllAccess)
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .accentColor(.fullPlayRed)
            .ignoresSafeArea(edges: .top)
            
            LogoView(frameWidth: 180).shadow(radius: 15)
            
            if viewModel.isLoading { LoadingView() }
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, onDismiss: {
            viewModel.getCheckedInCount()
        }, content: {
            NavigationView {
                LocationDetailView(viewModel: LocationDetailViewModel(location: locationManager.selectedLocation!))
                    .toolbar { Button("Dismiss", action: { viewModel.isShowingDetailView = false }) }
            }
        })
        .overlay(alignment: .bottomLeading, content: {
            LocationButton(.currentLocation) {
                viewModel.requiereAllowOnceLocationPermession()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.fullPlayRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        })
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .task {
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
                
            }
            viewModel.getCheckedInCount()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                Task {
                    await viewModel.getAllAccessStatus(for: purchasesManager)
                }
                viewModel.getLocations(for: locationManager)
                print("Active")
            } else if newPhase == .background {
                print("Background")
            }
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView().environmentObject(LocationManager())
    }
}
