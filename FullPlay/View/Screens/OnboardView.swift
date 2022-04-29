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
            
            featureView(imageName: "mappin.and.ellipse",
                        title: "Courts on the map",
                        description: "Find courts to play around you")
            
            featureView(imageName: "checkmark.circle",
                        title: "Check In",
                        description: "Let other players know where you are")
            
            featureView(imageName: "person.2.circle",
                        title: "Find Friends",
                        description: "See where other players are and join the game")
            
            Spacer()
            
            Text("Coming soon...")
                .font(.title3)
                .fontWeight(.bold)

            featureView(imageName: "clock.badge.checkmark",
                        title: "Organize matches",
                        description: "Setup matches on a specific court, date and time")
            
            featureView(imageName: "person.crop.circle.badge.checkmark",
                        title: "Auto Check In",
                        description: "Auto Check In in a court when you're there")
            
            
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
                .frame(width: 50, height: 50)
            
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
