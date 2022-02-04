//
//  OnboardView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

struct OnboardView: View {
    
    @Binding var isShowingOnboardView: Bool
    // @Enviroment(\.presentationMode) var presentationMode *** Using Enviroment presentationMode instead of @Binding
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    isShowingOnboardView = false
                    // presentationMode.wrappedValue.dismiss()
                } label: {
                    XDismissButton()
                }
                .padding()
            }
            
            Spacer()
            
            LogoView(frameWidth: 250)
            
            featureView(imageName: "building.2.crop.circle",
                        title: "Restaurant Locations",
                        description: "Find places to dine around the convention center")
            
            featureView(imageName: "checkmark.circle",
                        title: "Check In",
                        description: "Let other iOS Devs know where you are")
            
            featureView(imageName: "person.2.circle",
                        title: "Find Friends",
                        description: "See where other iOS Devs are and join the party")
            
            Spacer()
            
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(isShowingOnboardView: .constant(false))
    }
}

struct featureView: View {
    var imageName: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.brandPrimary)
                .frame(height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .padding(.leading)
            
            Spacer()
        }
        .frame(width: 300)
        .padding()
    }
}
