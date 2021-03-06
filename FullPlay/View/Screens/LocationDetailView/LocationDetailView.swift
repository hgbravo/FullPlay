//
//  LocationDetailView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI

struct LocationDetailView: View {
    
    @StateObject var viewModel: LocationDetailViewModel
    @EnvironmentObject private var purchasesManager: PurchasesManager
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 16) {
                BannerImageView(image: viewModel.location.createBannerImage())
                AddressHStack(address: viewModel.location.address)
                DescriptionView(text: viewModel.location.description)
                ActionButtonHStack(viewModel: viewModel)
                GridHeaderTextView(number: viewModel.checkedInProfiles.count)
                if purchasesManager.hasAllAccess {
                    AvatarGridView(viewModel: viewModel)
                } else {
                    NoAccessView(viewModel: viewModel)
                }
                Spacer()
            }
            .accessibilityHidden(viewModel.isShowingProfileModal)
            
            if viewModel.isShowingProfileModal {
                FullScreenBlackTransparencyView()
                
                ProfileModalView(isShowingProfileModal: $viewModel.isShowingProfileModal,
                                 profile: viewModel.profileForModal)
            }
            
            if viewModel.isShowingStoreModal {
                FullScreenBlackTransparencyView()
                
                StoreModalView(isShowingStoreModal: $viewModel.isShowingStoreModal)
            }
        }
        .task {
            viewModel.getCheckedInProfiles()
            viewModel.isCheckedInStatus()
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .navigationTitle(viewModel.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


fileprivate struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailView(viewModel: LocationDetailViewModel(location: FPLocation(record: MockData.location), currentLocation: MockData.mockLocation))
    }
}


fileprivate struct LocationActionButton: View {
    
    var color: Color
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }
}


fileprivate struct FirstNameAvatarView: View {
    
    var profile: FPProfile
    
    var body: some View {
        VStack {
            AvatarView(image: profile.avatarImage, size: 64)
            
            Text(profile.firstName)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .padding(.bottom)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Show's \(profile.firstName) profile pop up."))
        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
    }
}


fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}


fileprivate struct AddressHStack: View {
    
    var address: String
    
    var body: some View {
        HStack {
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal)
        
    }
}


fileprivate struct DescriptionView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .frame(height: 70)
            .padding(.horizontal)
            .padding(.bottom, 20)
    }
}


fileprivate struct GridHeaderTextView: View {
    
    var number: Int
    
    var body: some View {
        Text("Who's here?")
            .bold()
            .font(.title2)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(Text("Who is here? \(number) checked in"))
            .accessibilityHint(Text("Botton section is scrollable"))
    }
}


fileprivate struct GridEmptyStateTextView: View {
    var body: some View {
        Text("Nobody is here ????")
            .bold()
            .font(.title2)
            .foregroundColor(.secondary)
            .padding(.top, 30)
    }
}


fileprivate struct FullScreenBlackTransparencyView: View {
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .opacity(0.9)
        //                    .transition(.opacity)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .zIndex(1)
            .accessibilityHidden(true)
    }
}

fileprivate struct ActionButtonHStack: View {
    
    @StateObject var viewModel: LocationDetailViewModel
    @EnvironmentObject private var purchasesManager: PurchasesManager
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.getDirectionsToLocation()
            } label: {
                LocationActionButton(color: .brandPrimary, imageName: "location.fill")
            }
            .accessibilityLabel(Text("Get directions"))
            
            if let _ = CloudKitManager.shared.profileRecordID {
                Button {
                    if purchasesManager.hasAllAccess {
                        locationManager.requestAlwaysLocationPermession()
                        viewModel.updateCheckInStatus(to: viewModel.isCheckedIn ? .checkedOut : .checkedIn)
                    }
                    
                } label: {
                    if purchasesManager.hasAllAccess {
                        LocationActionButton(color: viewModel.buttonColor, imageName: viewModel.buttonImageTitle)
                    } else {
                        LocationActionButton(color: .brandPrimary, imageName: "questionmark")
                    }
                }
                .accessibilityLabel(Text(viewModel.buttonA11yLabel))
                .disabled(viewModel.isLoading || !purchasesManager.hasAllAccess)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color(.secondarySystemBackground))
        .clipShape(Capsule())
    }
}

fileprivate struct AvatarGridView: View {
    
    @StateObject var viewModel: LocationDetailViewModel
    
    var body: some View {
        ZStack {
            if viewModel.checkedInProfiles.isEmpty {
                // Empty state
                GridEmptyStateTextView()
            } else {
                ScrollView {
                    LazyVGrid(columns: viewModel.columns) {
                        ForEach(viewModel.checkedInProfiles) { profile in
                            FirstNameAvatarView(profile: profile)
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.profileForModal = profile
                                        viewModel.isShowingProfileModal = true
                                    }
                                }
                        }
                    }
                }
            }
            
            if viewModel.isLoading { LoadingView() }
        }
    }
}

fileprivate struct NoAccessView: View {
    
    @StateObject var viewModel: LocationDetailViewModel
    
    var body: some View {
//        Text("No Access")
//            .lineLimit(3)
//            .minimumScaleFactor(0.75)
//            .frame(height: 70)
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//            .font(.subheadline)
        
        Button("Get All Access Subscription") {
            withAnimation {
                viewModel.isShowingStoreModal = true
            }
        }
            .buttonStyle(.bordered)
            .tint(.brandPrimary)
            .controlSize(.large)
            .padding()
    }
}
