//
//  Constants.swift
//  FullPlay
//
//  Created by Henry Bravo on 2/2/22.
//

import Foundation
import UIKit

enum RecordType {
    static let location = "FPLocation"
    static let category = "FPCategory"
    static let zone     = "FPZone"
    static let profile  = "FPProfile"
}

enum PlaceholderImage {
    static let avatar = UIImage(named: "default-avatar")!
    static let square = UIImage(named: "default-square-asset")!
    static let banner = UIImage(named: "default-banner-asset")!
}

enum ImageDimension {
    case square, banner
    
    var placeholder: UIImage {
        switch self {
        case .square:
            return PlaceholderImage.square
        case .banner:
            return PlaceholderImage.banner
        }
    }
}
