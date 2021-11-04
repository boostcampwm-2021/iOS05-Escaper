//
//  RoomDTO.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation

struct RoomDTO: Codable {
    var name: String
    var storeName: String
    var level: Double
    var homePage: String
    var telephone: String
    var genres: [Genre]
    var geoLocation: GeoLocation
    var district: District
    var userRecords: [UserRecord]
    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "name": self.name,
            "storeName": self.storeName,
            "level": self.level,
            "homePage": self.homePage,
            "telephone": self.telephone,
            "genres": self.genres.map { $0.rawValue },
            "geoLocation": self.geoLocation.toDictionary,
            "district": self.district.rawValue,
            "userRecords": self.userRecords.map { $0.toDictionary }
        ]
        return dictionary
    }

    func toDomain() -> Room {
        let level = Rating(rawValue: Int(self.level.rounded())) ?? Rating.zero
        let satisfactionSum = self.userRecords.reduce(0.0, { $0 + $1.satisfaction })
        let satisfactionRawValue = self.userRecords.count == 0 ? 0 : (satisfactionSum / Double(self.userRecords.count)).rounded()
        let satisfaction = Rating(rawValue: Int(satisfactionRawValue)) ?? Rating.zero
        let userRecords = self.userRecords.sorted { $0.playTime > $1.playTime }.prefix(3).map { $0 }

        return Room(name: self.name,
                     storeName: self.storeName,
                     level: level,
                     satisfaction: satisfaction,
                     homepage: self.homePage,
                     telephone: self.telephone,
                     genres: self.genres,
                     geoLocation: self.geoLocation.clLocation,
                     district: self.district,
                     userRecords: userRecords)
    }
}
