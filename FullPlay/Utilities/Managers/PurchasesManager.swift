//
//  PurchasesManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 4/5/22.
//

import Foundation

@MainActor final class PurchasesManager: ObservableObject {
    @Published var hasAllAccess: Bool = false
}
