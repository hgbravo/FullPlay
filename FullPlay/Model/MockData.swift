//
//  MockData.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import Foundation
import CloudKit

struct MockData {
    
    static var location: CKRecord {
        let record                          = CKRecord(recordType: RecordType.location)
        record[FPLocation.kName]            = "Summerport Basketball Court"
        record[FPLocation.kAddress]         = "14600 Avenue of the Groves. Winter Garden, Fl. 34787"
        record[FPLocation.kDescription]     = "This is a test description. Actually, I guess this is goin to be enough to make it take 3 lines long. I wont know until now."
        record[FPLocation.kWebsiteURL]      = "https://apple.com"
        record[FPLocation.kLocation]        = CLLocation(latitude: 28.461783, longitude: -81.603323)
        record[FPLocation.kIsIndoorCheck]   = 0
        
        return record
    }
    
    
    static var category: CKRecord {
        let record                          = CKRecord(recordType: RecordType.category)
        record[FPCategory.kName]            = "Basketball Courts"
        record[FPCategory.kDescription]     = "Indoor and Outdoor Basketball Courts"
        
        return record
    }
    
    
    static var zone: CKRecord {
        let record                          = CKRecord(recordType: RecordType.zone)
        record[FPZone.kName]                = "Winter Garden, Fl"
        record[FPZone.kDescription]         = "Winter Garden is a city located 14 miles west of downtown Orlando in western Orange County, Florida, United States."
        record[FPZone.kLocation]            = CLLocation(latitude: 28.565017, longitude: -81.589506)
        
        return record
    }
    
    
    static var profile: CKRecord {
        let record                          = CKRecord(recordType: RecordType.profile)
        record[FPProfile.kFirstName]        = "HenrySuperLongFirstName"
        record[FPProfile.kLastName]         = "BravoSuperLongoLastName"
        record[FPProfile.kSocial]           = "@TryUrAppSuperLongSocialUser"
        record[FPProfile.kBio]              = "This is my Mock Data Bio. This is going great!"
        
        return record
    }
    
    
    static var mockLocation: CLLocation {
        let location                        = CLLocation(latitude: 28.47319, longitude: 81.64541)
        
        return location
    }
}
