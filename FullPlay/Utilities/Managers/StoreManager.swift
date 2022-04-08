////
////  StoreManager.swift
////  FullPlay
////
////  Created by Henry Bravo on 3/9/22.
////
//
//import Foundation
//import Purchases
//
//class StoreManager: ObservableObject {
//    
//    @Published var hasAllAccess: Bool = false
//    
//    
//    @MainActor func getAllAccessStatus() async throws -> Bool {
//        
//        // Check if user has an active subscription
//        let purchaserInfo = try await Purchases.shared.purchaserInfo()
//        if purchaserInfo.entitlements[Entitlements.allaccess]?.isActive == true {
//            return true
//        } else { return false }
//        
////        Task {
////            do {
////                let purchaserInfo = try await Purchases.shared.purchaserInfo()
////                guard let status = purchaserInfo.entitlements[Entitlements.allaccess]?.isActive else { return }
////                hasAllAccess = status
////
////                //saveAllAccessStatus()
////            }
////        }
//        
//    }
//    
//    
//    private func saveAllAccessStatus() {
//        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
//        
//        Task {
//            do {
//                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
//                
//                if hasAllAccess == true {
//                    record[FPProfile.khasAllAccess] = 1
//                } else {
//                    record[FPProfile.khasAllAccess] = nil
//                }
//                
//                let _ = try await CloudKitManager.shared.save(record: record)
//            }
//        }
//    }
//    
//    
//    func purchase(productID: String) async throws {
//        
//        guard let skProduct = await Purchases.shared.products([productID]).first else { return }
//        let (_, purchaserInfo, userCancelled) = try await Purchases.shared.purchaseProduct(skProduct)
//        
//        if purchaserInfo.entitlements[Entitlements.allaccess]?.isActive == true && userCancelled == false {
//            hasAllAccess = true
//        }
//    }
//    
//    @MainActor func purchaseAllAccess(productID: String?, successfullPurchase: @escaping () -> Void) {
//        
//        guard let productID = productID else { return }
//        
//        var skProduct: SKProduct?
//        
//        // Find product based on ID
//        Purchases.shared.products([productID]) { products in
//            
//            if !products.isEmpty {
//                skProduct = products[0]
//                
//                // Purchase it
//                Purchases.shared.purchaseProduct(skProduct!) { transaction, purchaseInfo, error, userCancelled in
//                    
//                    if error == nil && !userCancelled {
//                        
//                        self.hasAllAccess = true
//                        successfullPurchase()
//                    }
//                }
//            }
//        }
//    }
//}
