//
//  UIImage+Ext.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import Foundation
import UIKit
import CloudKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        
        // Get our apps base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Document Directory url came back nil")
            return nil
        }
        
        // Append some unique identifier for our profile image
        let fileURL = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // Write the image data to the location the address points to & Create the CKAsset with that fileURL
        guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }
        
        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            return nil
        }
    }
}

