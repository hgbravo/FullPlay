//
//  FPZone.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//


import CloudKit
import UIKit

struct FPZone: Identifiable {
    
    static let kName        = "name"
    static let kDescription = "description"
    static let kLocation    = "location"
    
    let id: CKRecord.ID
    let name: String
    let location: CLLocation
    
    init(record: CKRecord) {
        id          = record.recordID
        name        = record[FPLocation.kName] as? String ?? "N/A"
        location    = record[FPLocation.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
    }
}
