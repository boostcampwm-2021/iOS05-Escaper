//
//  Room.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

struct Room: Codable {
    var name: String
    var storeName: String
    var level: Double
    var homePage: String
    var telephone: String
    var genres: [Genre]
    var geoLocation: GeoLocation
    var address = ["서울특별시", "강남구", "역삼동"]
    var playedUsers: [UserRecord]

    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "name": self.name,
            "storeName": self.storeName,
            "level": self.level,
            "homePage": self.homePage,
            "telephone": self.telephone,
            "genres": self.genres.map { $0.rawValue },
            "geoLocation": self.geoLocation.toDictionary,
            "address": self.address,
            "playedUsers": self.playedUsers.map { $0.toDictionary }
        ]

        return dictionary
    }
}
