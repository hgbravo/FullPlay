//
//  LocationDetailViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

@MainActor final class LocationDetailViewModel: ObservableObject {
    
    @Published var checkedInProfiles: [FPProfile] = []
    @Published var profileForModal: FPProfile = FPProfile(record: MockData.profile)
    @Published var isShowingProfileModal = false
    @Published var isShowingStoreModal = false
    @Published var isCheckedIn = false
    @Published var isLoading = false
    @Published var alertItem: AlertItem?
    
    let columns = [GridItem(.flexible()),
                   GridItem(.flexible()),
                   GridItem(.flexible())]
    
    var location: FPLocation
    var buttonColor: Color { isCheckedIn ? .fullPlayRed : .brandPrimary }
    var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
    var buttonA11yLabel: String { isCheckedIn ? "Check out of location" : "Check into location" }
    
    init(location: FPLocation) { self.location = location }
    
    
    func getDirectionsToLocation() {
        let placemark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    
//    func callLocation() {
//        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
//            alertItem = AlertContext.invalidPhoneNumber
//            return
//        }
//
//        UIApplication.shared.open(url)
//    }
    
    
    func isCheckedInStatus() {
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                if let reference = record[FPProfile.kIsCheckedIn] as? CKRecord.Reference {
                    isCheckedIn = reference.recordID == location.id
                } else {
                    isCheckedIn = false
                }
            } catch {
                alertItem =  AlertContext.unableToGetCheckInStatus
            }
        }
    }
    
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus) {
        
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                switch checkInStatus {
                case .checkedIn:
                    record[FPProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[FPProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[FPProfile.kIsCheckedIn] = nil
                    record[FPProfile.kIsCheckedInNilCheck] = nil
                }
                
                let savedRecord = try await CloudKitManager.shared.save(record: record)
                HapticManager.playSuccess()
                // update our checkedInProfile array
                let profile = FPProfile(record: savedRecord)
                
                switch checkInStatus {
                case .checkedIn:
                    checkedInProfiles.append(profile)
                case .checkedOut:
                    checkedInProfiles.removeAll { $0.id == profile.id }
                }
                
                isCheckedIn.toggle()
                
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    
    func getCheckedInProfiles() {
        showLoadingView()
        
        Task {
            do {
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                hideLoadingView()
            } catch {
                hideLoadingView()
                alertItem = AlertContext.unableToGetCheckedInProfiles
            }
        }
    }
    
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
}
