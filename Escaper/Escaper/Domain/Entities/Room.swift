//
//  Room.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

struct Room: Hashable {
    var roomId: String
    var title: String
    var storeName: String
    var difficulty: Int
    var averageSatisfaction: Double
    var genre: Genre
    var geoLocation: CLLocation
    var district: District
    var records: [Record]
    var distance: Double

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.roomId)
    }

    mutating func updateDistance(_ distance: Double) {
        self.distance = distance
    }

    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomId == rhs.roomId
    }
}
