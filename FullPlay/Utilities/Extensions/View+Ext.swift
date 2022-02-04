//
//  View+Ext.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/4/22.
//

import SwiftUI

extension View {
    func profileNameStyle() -> some View {
        self.modifier(ProfileNameText())
    }
}
