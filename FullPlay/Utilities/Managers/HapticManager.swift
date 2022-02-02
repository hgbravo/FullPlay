//
//  HapticManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import UIKit

struct HapticManager {
    
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
