//
//  FPProfile.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import CloudKit
import UIKit

struct FPProfile: Identifiable {
    static let kFirstName           = "firstName"
    static let kLastName            = "lastName"
    static let kAvatar              = "avatar"
    static let kSocial              = "social"
    static let kBio                 = "bio"
    static let kIsCheckedIn         = "isCheckedIn"
    static let kIsCheckedInNilCheck = "isCheckedInNilCheck"
    
    let id: CKRecord.ID
    let firstName: String
    let lastName: String
    let avatar: CKAsset!
    let social: String
    let bio: String
    
    init(record: CKRecord) {
        id          = record.recordID
        firstName   = record[FPProfile.kFirstName] as? String ?? "N/A"
        lastName    = record[FPProfile.kLastName] as? String ?? "N/A"
        avatar      = record[FPProfile.kAvatar] as? CKAsset
        social      = record[FPProfile.kSocial] as? String ?? "N/A"
        bio         = record[FPProfile.kBio] as? String ?? "N/A"
    }
    
    
    var avatarImage: UIImage {
        guard let avatar = avatar else { return PlaceholderImage.avatar }
        return avatar.convertToUIImage(in: .square)
    }
}
