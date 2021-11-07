//
//  GeoLocation.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/03.
//

import Foundation
import CoreLocation

struct GeoLocation: Codable {
    let latitude: Double
    let longitude: Double
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "latitude": self.latitude,
            "longitude": self.longitude
        ]
        return dictionary
    }
    var clLocation: CLLocation {
        return CLLocation.init(latitude: self.latitude, longitude: self.longitude)
    }
}
