//
//  Room.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

struct Room: Hashable {
    var identifier: String
    var name: String
    var storeName: String
    var level: Rating
    var satisfaction: Rating
    var homepage: String
    var telephone: String
    var genres: [Genre]
    var geoLocation: CLLocation
    var district: District
    var distance: Double
    var userRecords: [UserRecord]

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.storeName)
    }

    mutating func updateDistance(_ distance: Double) {
        self.distance = distance
    }

    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.name == rhs.name && lhs.storeName == rhs.storeName
    }
}
