//
//  FPCategory.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import CloudKit
import UIKit

struct FPCategory: Identifiable {
    
    static let kName        = "name"
    static let kDescription = "description"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"

    
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!

    
    init(record: CKRecord) {
        id          = record.recordID
        name        = record[FPLocation.kName] as? String ?? "N/A"
        description = record[FPLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[FPLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[FPLocation.kBannerAsset] as? CKAsset
    }
    
    func createSquareImage() -> UIImage {
        guard let asset = squareAsset else { return PlaceholderImage.square }
        return asset.convertToUIImage(in: .square)
    }
    
    
    func createBannerImage() -> UIImage {
        guard let asset = bannerAsset else { return PlaceholderImage.banner }
        return asset.convertToUIImage(in: .banner)
    }
}
