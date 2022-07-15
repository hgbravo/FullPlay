//
//  StoreModalViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 3/28/22.
//

import Foundation
import Purchases

extension StoreModalView {
    
    @MainActor final class StoreModalViewModel: ObservableObject {
        @Published var alertItem: AlertItem?
        @Published var isLoading = false
        
        func makePurchase(productID: String, purchasesManager: PurchasesManager) async {
            showLoadingView()
            do {
                guard let skProduct = await Purchases.shared.products([productID]).first else { return }
                let (_, purchaserInfo, userCancelled) = try await Purchases.shared.purchaseProduct(skProduct)
                
                if purchaserInfo.entitlements[Entitlements.allaccess]?.isActive == true && userCancelled == false {
                    purchasesManager.hasAllAccess = true
                }
                hideLoadingView()
            } catch {
                self.hideLoadingView()
                self.alertItem = AlertContext.unableToProcessPurchase
            }
        }
        
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
        
    }
}
