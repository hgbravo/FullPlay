//
//  StoreModalViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 3/28/22.
//

import Foundation
import Purchases

extension StoreModalView {
    
    final class StoreModalViewModel: ObservableObject {
        @Published var alertItem: AlertItem?
        @Published var isLoading = false
        
        @MainActor func makePurchase(productID: String, purchasesManager: PurchasesManager) async {
            do {
                guard let skProduct = await Purchases.shared.products([productID]).first else { return }
                let (_, purchaserInfo, userCancelled) = try await Purchases.shared.purchaseProduct(skProduct)
                
                if purchaserInfo.entitlements[Entitlements.allaccess]?.isActive == true && userCancelled == false {
                    purchasesManager.hasAllAccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertItem = AlertContext.unableToProcessPurchase
                }
            }
        }
        
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
        
    }
}
