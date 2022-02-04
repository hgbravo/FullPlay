//
//  CustomModifiers.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI


struct ProfileNameText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .disableAutocorrection(true)
    }
}

