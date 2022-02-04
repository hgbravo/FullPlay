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
    
    
    func getLocations() async throws -> [FPLocation] {
        let sortDescriptor      = NSSortDescriptor(key: FPLocation.kName, ascending: true)
        let query               = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors   = [sortDescriptor]
        
        
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
    
}
