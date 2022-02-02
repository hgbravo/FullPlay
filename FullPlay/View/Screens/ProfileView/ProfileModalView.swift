//
//  ProfileModalView.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI

struct ProfileModalView: View {
    
    @Binding var isShowingProfileModal: Bool
    var profile: FPProfile
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer().frame(height: 60)
                    Text(profile.firstName + " " + profile.lastName)
                        .bold()
                        .font(.title2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal)
                    
                    Text(profile.social)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .foregroundColor(.secondary)
                        .accessibilityLabel(Text("Works at \(profile.social)"))
                        .padding(.horizontal)
                    
                    Text(profile.bio)
                        .lineLimit(3)
                        .minimumScaleFactor(0.75)
                        .padding()
                        .accessibilityLabel(Text("Bio, \(profile.bio)"))
                }
                .frame(width: geo.size.width * 0.75, height: 230)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)
                .overlay(alignment: .topTrailing, content: {
                    Button {
                        withAnimation { isShowingProfileModal = false }
                    } label: {
                        XDismissButton()
                    }
                })
                .frame(width: geo.size.width, height: geo.size.height)
                
                Image(uiImage: profile.avatarImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 110)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 6)
                    .offset(y: -120)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityAddTraits(.isModal)
        .transition(.opacity.combined(with: .slide))
        .zIndex(2)
    }
}

struct ProfileModalView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModalView(isShowingProfileModal: .constant(true),
                         profile: FPProfile(record: MockData.profile))
    }
}
