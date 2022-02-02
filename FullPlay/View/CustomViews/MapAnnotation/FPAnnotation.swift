//
//  FPAnnotation.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import SwiftUI

struct FPAnnotation: View {
    var location: FPLocation
    var number: Int
    
    var body: some View {
        VStack {
            ZStack {
                MapBalloon()
                    .frame(width: 100, height: 75)
                    .foregroundColor(.brandPrimary)
                
                Image(uiImage: location.createSquareImage())
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -15)
                
                if number > 0 {
                    Text("\(min(number, 99))")
                        .font(.system(size: 11, weight: .bold))
                        .frame(width: 26, height: 18)
                        .background(Color.fullPlayRed)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .offset(x: 20, y: -28)
                }
            }
            
            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
            
        }
        .accessibilityLabel("Map Pin \(location.name) \(number) checked in.")
    }
}

struct DDGAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        FPAnnotation(location: FPLocation(record: MockData.location), number: 44)
    }
}
