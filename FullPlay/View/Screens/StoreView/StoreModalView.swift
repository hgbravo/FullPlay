//
//  StoreView.swift
//  FullPlay
//
//  Created by Henry Bravo on 3/24/22.
//

import SwiftUI

struct StoreModalView: View {
    @Binding var isShowingStoreModal: Bool
    @EnvironmentObject private var storeManager: StoreManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer().frame(height: 60)
                    Text("Get the All Access Package to enjoy all features")
                        .bold()
                        .font(.subheadline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal)
                    
                    Button("All Access Monthly - $3.99") {
                        storeManager.purchaseAllAccess(productID: "fp_399_1m") {
                            storeManager.hasAllAccess = true
                            isShowingStoreModal = false
                        }
                    }
                        .buttonStyle(.bordered)
                        .tint(.brandPrimary)
                        .controlSize(.large)
                        .padding()
                    Spacer()
                }
                .frame(width: geo.size.width * 0.85, height: 230)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        withAnimation { isShowingStoreModal = false }
                    } label: {
                        XDismissButton()
                    }
                })
                .frame(width: geo.size.width, height: geo.size.height)
                
                Image("default-square-asset")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                    .offset(y: -120)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityAddTraits(.isModal)
        .transition(.opacity.combined(with: .slide))
        .zIndex(2)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreModalView(isShowingStoreModal: .constant(true))
    }
}
