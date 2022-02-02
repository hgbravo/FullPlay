//
//  LocationManager.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import Foundation

final class LocationManager: ObservableObject {
    @Published var locations: [FPLocation] = []
    var selectedLocation: FPLocation?
}
