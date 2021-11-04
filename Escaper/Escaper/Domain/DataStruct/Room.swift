//
//  Room.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

struct Room {
    var name: String
    var storeName: String
    var level: Rating
    var satisfaction: Rating
    var homepage: String
    var telephone: String
    var genres: [Genre]
    var geoLocation: CLLocation
    var district: District
    var userRecords: [UserRecord]
}
