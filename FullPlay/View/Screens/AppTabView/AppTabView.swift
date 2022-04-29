//
//  AppTabView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

private enum Tab: Hashable {
    case map
    case list
    case profile
}

struct AppTabView: View {
    @StateObject private var viewModel = AppTabViewModel()
    @State private var selectedTab: Tab = .map
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LocationMapView()
                .tabItem { Label("Map", systemImage: "mappin.and.ellipse") }
                .tag(Tab.map)
            
            LocationListView()
                .tabItem { Label("Courts", systemImage: "sportscourt") }
                .tag(Tab.list)
            
            NavigationView { ProfileView() }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(Tab.profile)
        }
        .task {
            try? await CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }
        .sheet(isPresented: $viewModel.isShowingOnboardView) {
            OnboardView(isShowingOnboardView: $viewModel.isShowingOnboardView)
            // OnboardView() *** Using Enviroment presentationMode instead of @Binding on OnboardingView
        }
        .onAppear {
            print("TabBar Appears")
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
