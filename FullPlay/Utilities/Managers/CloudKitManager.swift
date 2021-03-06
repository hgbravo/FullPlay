//
//  CloudKitManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() {}
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    let container = CKContainer.default()
    
    
    func getUserRecord() async throws {
        
        let recordID = try await container.userRecordID()
        let record = try await container.publicCloudDatabase.record(for: recordID)
        
        userRecord = record
        
        if let profileReference = record["userProfile"] as? CKRecord.Reference {
            profileRecordID = profileReference.recordID
        }
    }
    
    
    func getZones() async throws -> [FPZone] {
        let sortDescriptor = NSSortDescriptor(key: FPZone.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.zone, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(FPZone.init)
    }
    
    
    func getLocations() async throws -> [FPLocation] {
        let sortDescriptor      = NSSortDescriptor(key: FPLocation.kName, ascending: true)
        let query               = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors   = [sortDescriptor]
        
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(FPLocation.init)
        
    }
    
    
    func getLocations(for categoryID: CKRecord.ID) async throws -> [FPLocation] {
        let reference = CKRecord.Reference(recordID: categoryID, action: .none)
        let predicate = NSPredicate(format: "category == %@", reference)
        let query = CKQuery(recordType: RecordType.location, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(FPLocation.init)
    }
    
    
    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [FPProfile] {
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        return records.map(FPProfile.init)
    }
    
    
    func getCheckedInProfilesDictionary() async throws -> [CKRecord.ID: [FPProfile]] {
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID: [FPProfile]] = [:]
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        for record in records {
            let profile = FPProfile(record: record)
            guard let locationReference = record[FPProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        guard let cursor = cursor else { return checkedInProfiles }
        
        do {
            return try await CloudKitManager.shared.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
        
    }
    
    
    private func continueWithCheckedInProfilesDict(cursor: CKQueryOperation.Cursor,
                                                   dictionary: [CKRecord.ID: [FPProfile]]) async throws -> [CKRecord.ID: [FPProfile]] {
        
        var checkedInProfiles = dictionary
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor)
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        for record in records {
            let profile = FPProfile(record: record)
            guard let locationReference = record[FPProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            checkedInProfiles[locationReference.recordID, default: []].append(profile)
        }
        
        guard let cursor = cursor else { return checkedInProfiles }
        
        do {
            return try await CloudKitManager.shared.continueWithCheckedInProfilesDict(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    
    func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int] {
        let predicate           = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query               = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query, desiredKeys: [FPProfile.kIsCheckedIn])
        let records = matchResults.compactMap { _, result in try? result.get() }
        
        for record in records {
            guard let locationReference = record[FPProfile.kIsCheckedIn] as? CKRecord.Reference else { continue }
            
            if let count = checkedInProfiles[locationReference.recordID] {
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        
        return checkedInProfiles
    }
    
    
    func batchSave(records: [CKRecord]) async throws -> [CKRecord] {
        
        let (savedResult, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResult.compactMap { _, result in try? result.get() }
    }
    
    
    func save(record: CKRecord) async throws -> CKRecord {
        return try await container.publicCloudDatabase.save(record)
        
    }
    
    
    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord {
        return try await container.publicCloudDatabase.record(for: id)
    }
    
    
    func subscribeToNotifications(of record: CKRecord.RecordType, subscriptionID: String, completed: @escaping (Result<CKRecord.RecordType, Error>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: record, predicate: predicate, subscriptionID: subscriptionID, options: .firesOnRecordCreation)
        
        let notification                    = CKSubscription.NotificationInfo()
        notification.title                  = "New Court"
        notification.alertLocalizationKey   = "%1$@"
        notification.alertLocalizationArgs  = ["name"]
        notification.alertBody              = "%1$@ has been added to your Couts. Open Full Play to check this new court!"
        notification.soundName              = "default"
        
        subscription.notificationInfo       = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSubscription, error in
            if let error = error {
                completed(.failure(error))
            } else {
                print("Successfully subscribed to notification")
                completed(.success(record))
            }
        }
    }
    
    
    func subscribeToGeneralNotifications(of record: CKRecord.RecordType, subscriptionID: String, completed: @escaping (Result<CKRecord.RecordType, Error>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: record, predicate: predicate, subscriptionID: subscriptionID, options: .firesOnRecordCreation)
        
        let notification                        = CKSubscription.NotificationInfo()
        notification.alertLocalizationKey       = "%1$@"
        notification.alertLocalizationArgs      = ["body"]
        notification.titleLocalizationKey       = "%1$@"
        notification.titleLocalizationArgs      = ["title"]
        notification.subtitleLocalizationKey    = "%2$@"
        notification.subtitleLocalizationArgs   = ["subtitle"]
        notification.title                      = "%1$@"
        notification.subtitle                   = "%2$@"
        notification.alertBody                  = "%1$@!"
        notification.soundName                  = "default"
        notification.desiredKeys                = ["title", "subtitle", "body"]
        notification.shouldSendContentAvailable = true
        
        subscription.notificationInfo       = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSubscription, error in
            if let error = error {
                completed(.failure(error))
            } else {
                print("Successfully subscribed to notification")
                completed(.success(record))
            }
        }
    }
    
    
    func unsubscribeToNotification(of subscriptionID: String, completed: @escaping (Result<String?, Error>) -> Void) {
        container.publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedSubscriptionID, error in
            if let error = error {
                completed(.failure(error))
            } else {
                completed(.success(returnedSubscriptionID))
            }
        }
    }
}
