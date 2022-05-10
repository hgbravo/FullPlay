//
//  ProfileViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import CloudKit
import UIKit

enum ProfileContext { case create, update }

extension ProfileView {
    
    final class ProfileViewModel: ObservableObject {
        @Published var firstName            = ""
        @Published var lastName             = ""
        @Published var social               = ""
        @Published var bio                  = ""
        @Published var avatar               = PlaceholderImage.avatar
        @Published var isShowingPhotoPicker = false
        @Published var isLoading            = false
        @Published var isCheckedIn          = false
        @Published var alertItem: AlertItem?
        
        private var existingProfileRecord: CKRecord? {
            didSet { profileContext = .update }
        }
        var profileContext: ProfileContext = .create
        var buttonTitle: String { profileContext == .create ? "Create profile" : "Update Profile" }
        
        private func isValidProfile() -> Bool {
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !social.isEmpty,
                  !bio.isEmpty,
                  avatar != PlaceholderImage.avatar,
                  bio.count <= 100 else { return false }
            
            return true
        }
        
        
        @MainActor func isCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    if let _ = record[FPProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = true
                    } else {
                        isCheckedIn = false
                    }
                } catch {
                    print("Unable to get status")
                }
            }
        }
        
        
        @MainActor func checkOut() {
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                    record[FPProfile.kIsCheckedIn] = nil
                    record[FPProfile.kIsCheckedInNilCheck] = nil
                    
                    let _ = try await CloudKitManager.shared.save(record: record)
                    HapticManager.playSuccess()
                    isCheckedIn = false
                    hideLoadingView()
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                }
            }
        }
        
        
        @MainActor func determineButtonAction() {
            profileContext == .create ? createProfile() : updateProfile()
        }
        
        
        @MainActor private func createProfile() {
            guard isValidProfile() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            // Create our CKRecord from the profile view
            let profileRecord = createProfileRecord()
            
            // Get our UserRecordId from the container **This happens in background with CloudKitManager
            // Get UserRecord from the Public Database
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            
            // Create reference on USerRecord to the DDGProfile we created
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            showLoadingView()
            
            Task {
                do {
                    let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                    for record in records where record.recordType == RecordType.profile {
                        existingProfileRecord = record
                        CloudKitManager.shared.profileRecordID = record.recordID
                    }
                    hideLoadingView()
                    
                    alertItem = AlertContext.createProfileSuccess
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.createProfileFailure
                }
            }
        }
        
        
        @MainActor func getProfile() {
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            
            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
            let profileRecordID = profileReference.recordID
            
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    existingProfileRecord = record
                    
                    let profile = FPProfile(record: record)
                    firstName   = profile.firstName
                    lastName    = profile.lastName
                    social = profile.social
                    bio         = profile.bio
                    avatar      = profile.avatarImage
                    
                    hideLoadingView()
                } catch {
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
        
        
        @MainActor private func updateProfile() {
            guard isValidProfile() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            guard let profileRecord = existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            profileRecord[FPProfile.kFirstName] = firstName
            profileRecord[FPProfile.kLastName] = lastName
            profileRecord[FPProfile.kSocial] = social
            profileRecord[FPProfile.kBio] = bio
            profileRecord[FPProfile.kAvatar] = avatar.convertToCKAsset()
            
            showLoadingView()
            
            Task {
                do {
                    let _ = try await CloudKitManager.shared.save(record: profileRecord)
                    hideLoadingView()
                    alertItem = AlertContext.updateProfileSuccess
                } catch {
                    alertItem = AlertContext.updateProfileFailure
                }
            }
        }
        
        
        private func createProfileRecord() -> CKRecord {
            
            let profileRecord = CKRecord(recordType: RecordType.profile)
            profileRecord[FPProfile.kFirstName] = firstName
            profileRecord[FPProfile.kLastName] = lastName
            profileRecord[FPProfile.kSocial] = social
            profileRecord[FPProfile.kBio] = bio
            profileRecord[FPProfile.kAvatar] = avatar.convertToCKAsset()
            
            return profileRecord
        }
        
        
        func shareSheet(url: String) {
            let url = URL(string: url)
            let activityView = UIActivityViewController(activityItems: ["Hey I'm using this amazing App for checking who's playing in our favorites courts,check it out!!!\n\(url!)"], applicationActivities: nil)

            let allScenes = UIApplication.shared.connectedScenes
            let scene = allScenes.first { $0.activationState == .foregroundActive }

            if let windowScene = scene as? UIWindowScene {
                windowScene.keyWindow?.rootViewController?.present(activityView, animated: true, completion: nil)
            }
        }
        
        
        @MainActor func requestNotificationPermissions() {
            
            let options: UNAuthorizationOptions = [.alert, .sound, .badge]
            
            Task {
                do {
                    try await UNUserNotificationCenter.current().requestAuthorization(options: options)
                    print("Permissions granted!")
                    
                    UIApplication.shared.registerForRemoteNotifications()
                } catch {
                    print("Error getting notifications permissions.")
                }
            }
        }
        
        
        func subscribeToNotifications() {
            
        }
        
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
        
    }
    
}
