//
//  FPLocation.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import CloudKit
import UIKit

struct FPLocation: Identifiable {
    
    static let kName        = "name"
    static let kDescription = "description"
    static let kCategory    = "category"
    static let kSquareAsset = "squareAsset"
    static let kBannerAsset = "bannerAsset"
    static let kAddress     = "address"
    static let kLocation    = "location"
    static let kZone        = "zone"
    static let kWebsiteURL  = "websiteURL"
    
    let id: CKRecord.ID
    let name: String
    let description: String
    let squareAsset: CKAsset!
    let bannerAsset: CKAsset!
    let address: String
    let location: CLLocation
    let websiteURL: String
    
    init(record: CKRecord) {
        id          = record.recordID
        name        = record[FPLocation.kName] as? String ?? "N/A"
        description = record[FPLocation.kDescription] as? String ?? "N/A"
        squareAsset = record[FPLocation.kSquareAsset] as? CKAsset
        bannerAsset = record[FPLocation.kBannerAsset] as? CKAsset
        address     = record[FPLocation.kAddress] as? String ?? "N/A"
        location    = record[FPLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        websiteURL  = record[FPLocation.kWebsiteURL] as? String ?? "N/A"
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
