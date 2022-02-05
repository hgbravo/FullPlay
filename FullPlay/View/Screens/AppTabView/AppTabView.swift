//
//  AppTabView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

struct AppTabView: View {
    @StateObject private var viewModel = AppTabViewModel()
    @State private var selectedTab = LocationMapView.tag
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LocationMapView()
                .tabItem { Label("Map", systemImage: "map") }
                .tag(LocationMapView.tag)
            
            LocationListView()
                .tabItem { Label("Courts", systemImage: "sportscourt") }
                .tag(LocationListView.tag)
            
            NavigationView { ProfileView() }
            .tabItem {
                Label("Profile", systemImage: "person")
                //.environment(\.symbolVariants, .none)
            }
            .tag(ProfileView.tag)
        }
        .task {
            try? await CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }
        .sheet(isPresented: $viewModel.isShowingOnboardView) {
            OnboardView(isShowingOnboardView: $viewModel.isShowingOnboardView)
            // OnboardView() *** Using Enviroment presentationMode instead of @Binding on OnboardingView
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
