//
//  LocationListView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

struct LocationListView: View {
    static let tag = 1
    @EnvironmentObject private var locationManager: LocationManager
    @StateObject private var viewModel = LocationListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination: LocationDetailView(viewModel: LocationDetailViewModel(location: location))) {
                        LocationListCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(viewModel.createVoiceOverSumary(for: location))
                    }
                }
            }
            .navigationTitle("Grub Spots")
            .listStyle(.plain)
            .task { await viewModel.getCheckedInProfilesDisctionary() }
            .refreshable { await viewModel.getCheckedInProfilesDisctionary() }
            .alert(item: $viewModel.alertItem, content: { $0.alert })
            
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
