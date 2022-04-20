//
//  LocationListCell.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

struct LocationListCell: View {
    
    @EnvironmentObject private var purchasesManager: PurchasesManager
    var location: FPLocation
    var profiles: [FPProfile]
    
    var body: some View {
        HStack {
            Image(uiImage: location.createSquareImage())
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .padding(.vertical, 8)
                
            
            VStack(alignment: .leading) {
                Text(location.name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .truncationMode(.tail)
                    .fixedSize(horizontal: false, vertical: true)
                    
                if !purchasesManager.hasAllAccess {
                    HStack {
                        ForEach(1..<5) { index in
                            AvatarView(image: UIImage(named: "default-avatar")!, size: 35)
                                .blur(radius: 2.0, opaque: false)
                        }
                    }
                } else {
                    if profiles.isEmpty {
                        Text("Nobody is Checked In")
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.top, 1)
                    } else {
                        HStack {
                            ForEach(profiles.indices, id: \.self) { index in
                                if index <= 3 {
                                    AvatarView(image: profiles[index].avatarImage, size: 35)
                                } else if index == 4 {
                                    AdditionalProfilesView(number: min(profiles.count - 4, 99))
                                }
                            }
                        }
                    }
                }
            }
            .padding(.leading)
        }
    }
}

struct LocationListCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationListCell(location: FPLocation(record: MockData.location), profiles: [])
    }
}


fileprivate struct AdditionalProfilesView: View {
    
    var number: Int
    
    var body: some View {
        Text("+\(number)")
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .clipShape(Circle())
    }
}

