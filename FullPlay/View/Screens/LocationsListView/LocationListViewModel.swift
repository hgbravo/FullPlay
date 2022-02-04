//
//  LocationListViewModel.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import Foundation
import CloudKit

extension LocationListView {
    
    @MainActor final class LocationListViewModel: ObservableObject {
        @Published var checkedInProfiles: [CKRecord.ID: [FPProfile]] = [:]
        @Published var alertItem: AlertItem?
        
        
        func getCheckedInProfilesDisctionary() async  {
            do {
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                print("Called")
            } catch {
                alertItem = AlertContext.unableToGetAllCheckedInProfiles
            }
        }
        
        
        func createVoiceOverSumary(for location: FPLocation) -> String {
            let count = checkedInProfiles[location.id, default: []].count
            
            let peoplePlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(peoplePlurality) checked in"
        }
    }
}
