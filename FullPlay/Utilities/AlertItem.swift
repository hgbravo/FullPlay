//
//  AlertItem.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

struct AlertContext {
    
    //MARK: - MapView Errors
    static let unableToGetLocations                 = AlertItem(title: Text("Location Error"),
                                                                message: Text("Unable to retrieve locations at this time.\nPlease try againg."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let locationRestricted                   = AlertItem(title: Text("Location Restricted"),
                                                                message: Text("Your llocations is restricted. This may be due to parental control."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let locationDenied                       = AlertItem(title: Text("Location Denied"),
                                                                message: Text("""
                                                              Dub Dub Grub does not have permission to have your location.\nTo change that go to your phone's \
                                                              settings > Dub Dub Grub > Location.
                                                              """),
                                                                dismissButton: .default(Text("Ok")))
    
    static let locationDisabled                     = AlertItem(title: Text("Location Disabled"),
                                                                message: Text("""
                                                              Your phone's location services are disabled.\nTo change that go to your phone's \
                                                              settings > Privacy > Location Services.
                                                              """),
                                                                dismissButton: .default(Text("Ok")))
    
    static let checkedInCount                       = AlertItem(title: Text("Failed to Get Profiles"),
                                                                message: Text("Unable to get the number of people checked into each location.\nPlease check your internet connection and try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    //MARK: - LocationListView Errors
    static let unableToGetAllCheckedInProfiles      = AlertItem(title: Text("Failed to Get Profiles"),
                                                                message: Text("Unable to get the number of people checked into each location.\nPlease check your internet connection and try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    //MARK: - ProfileView Errors
    static let invalidProfile                       = AlertItem(title: Text("Invalid Profile"),
                                                                message: Text("All fields are requiered as well as profile photo. Your bio must be < 100 characters.\nPlease try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let noUserRecord                         = AlertItem(title: Text("No User Record"),
                                                                message: Text("You must log into iCLoud on your phone in order to utilize Dub Dub Grub's Profile.\nPlease log in on your phone settings screen."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let createProfileSuccess                 = AlertItem(title: Text("Profile Created Successfully!"),
                                                                message: Text("Your profile has successfully been created."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let createProfileFailure                 = AlertItem(title: Text("Failed to Create Profile"),
                                                                message: Text("We were unable to create your profile at this time.\nPlease try again later or contact customer support if this persists."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetProfile                   = AlertItem(title: Text("Unable to Retrieve Profile"),
                                                                message: Text("We were unable to retrieve your profile at this time. Please check your internet connection and try again later or contact customer support if this persists."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let updateProfileSuccess                 = AlertItem(title: Text("Profile Update Success!"),
                                                                message: Text("Your Dub Dub Grub Profile was updated successfully."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let updateProfileFailure                 = AlertItem(title: Text("Unable to Update Profile"),
                                                                message: Text("We were unable to update your profile at this time.\nPlease check your internet connection and try again later or contact customer support if this persists."),
                                                                dismissButton: .default(Text("Ok")))
    
    //MARK: - LocationDetailView Errors
    static let invalidPhoneNumber                   = AlertItem(title: Text("Invalid Phone Number"),
                                                                message: Text("The phone number for the location is invalid. Please get the right one."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckInStatus             = AlertItem(title: Text("Server Error"),
                                                                message: Text("Unable to retrieve checked in status of the current user.\nPlease try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToCheckInOrOut                 = AlertItem(title: Text("Server Error"),
                                                                message: Text("We are unable to check in/out at this time.\nPlease try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckedInProfiles         = AlertItem(title: Text("Server Error"),
                                                                message: Text("We are unable to get users checked into this location at this time.\nPlease try again."),
                                                                dismissButton: .default(Text("Ok")))
    
    //MARK: - Store Errors
    static let hasNotAllAccess                      = AlertItem(title: Text("No Access"),
                                                                message: Text("This feature is included with the All Access Subscription. Please get a Monthly or Yearly Subscription to enjoy all the features."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetAllAccessStatus           = AlertItem(title: Text("Server Error"),
                                                                message: Text("We are unable to get All Access Status at this time.\nPlease check your internet connection and try again later or contact customer support if this persists."),
                                                                dismissButton: .default(Text("Ok")))
    
    static let unableToProcessPurchase              = AlertItem(title: Text("Purchase Error"),
                                                                message: Text("We are unable to process your purchase.\nPlease check your internet connection and try again."),
                                                                dismissButton: .default(Text("Ok")))
}
