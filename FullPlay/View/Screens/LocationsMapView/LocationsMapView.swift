//
//  LocationsMapView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct LocationMapView: View {
    static let tag = 0
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    FPAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .accentColor(.fullPlayRed)
            .ignoresSafeArea(edges: .top)
            
            LogoView(frameWidth: 125).shadow(radius: 15)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, onDismiss: {
            viewModel.getCheckedInClount()
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
            if locationManager.locations.isEmpty { viewModel.getLocations(for: locationManager) }
            viewModel.getCheckedInClount()
        }
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView().environmentObject(LocationManager())
    }
}
