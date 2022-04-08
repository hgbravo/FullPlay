//
//  StoreView.swift
//  FullPlay
//
//  Created by Henry Bravo on 3/24/22.
//

import SwiftUI

struct StoreModalView: View {
    @EnvironmentObject private var purchasesManager: PurchasesManager
    @StateObject private var viewModel = StoreModalViewModel()
    @Binding var isShowingStoreModal: Bool
    @State private var buttonMaxWidth: CGFloat?
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Image("default-square-asset")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                        .accessibilityHidden(true)
                        .padding(.top)
                    
                    Spacer().frame(height: 45)
                    
                    Text("Get the All Access Package to enjoy all features")
                        .foregroundColor(.primary)
                        .bold()
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                    //                        .minimumScaleFactor(0.8)
                        .padding(.horizontal)
                    
                    Group {
                        Button("All Access Monthly - $3.99") {
                            Task {
                                await viewModel.makePurchase(productID: "fp_399_1m", purchasesManager: purchasesManager)
                                isShowingStoreModal = false
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.brandSecondary)
                        .controlSize(.large)
                        .padding(.vertical)
                        
                        Button("All Access Yearly - $38.99") {
                            Task {
                                await viewModel.makePurchase(productID: "fp_399_1m", purchasesManager: purchasesManager)
                                isShowingStoreModal = false
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.brandPrimary)
                        .controlSize(.large)
                        .padding(.bottom)
                        
                        Button("All Access Lifetime - $59.99") {
                            Task {
                                await viewModel.makePurchase(productID: "fp_399_1m", purchasesManager: purchasesManager)
                                isShowingStoreModal = false
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.brandTertiary)
                        .controlSize(.large)
                        .padding(.bottom)
                    }
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: ButtonWidthPreferenceKey.self,
                            value: geometry.size.width
                        )
                    })
                    .frame(width: buttonMaxWidth)
                    
                    Spacer()
                }
                .onPreferenceChange(ButtonWidthPreferenceKey.self) {
                    buttonMaxWidth = $0
                }
                .fixedSize(horizontal: false, vertical: true)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        withAnimation { isShowingStoreModal = false }
                    } label: {
                        XDismissButton()
                    }
                    .offset(x: 15, y: -15)
                })
                .frame(width: geo.size.width, height: geo.size.height)
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

private extension StoreModalView {
    struct ButtonWidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}
