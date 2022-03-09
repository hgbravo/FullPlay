//
//  StoreManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 3/9/22.
//

import Foundation
import Purchases

class StoreManager {
    
    static func purchase(productID: String?, successfulPurchase: @escaping () -> Void) {
        
        guard let productID = productID else {
            return
        }
        
        var skProduct: SKProduct?
        
        // Find product based on ID
        Purchases.shared.products([productID]) { products in
            
            if !products.isEmpty {
                skProduct = products[0]
                
                // Purchase it
                Purchases.shared.purchaseProduct(skProduct!) { transaction, purchaseInfo, error, userCancelled in
                    
                    if error == nil && !userCancelled {
                        successfulPurchase()
                    }
                }
            }
        }
    }
}
