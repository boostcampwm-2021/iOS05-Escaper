//
//  Store.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/17.
//

import Foundation
import CoreLocation

struct Store: Hashable {
    var name: String
    var homePage: String
    var telephone: String
    var address: String
    var region: StoreRegion
    var geoLocation: CLLocation
    var district: District
    var roomIds: [String]
    var distance: Double

    mutating func updateDistance(_ distance: Double) {
        self.distance = distance
    }
}
