//
//  RoomDTO.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation

struct RoomDTO: Codable {
    var roomId: String
    var title: String
    var storeName: String
    var difficulty: Int
    var genre: String
    var geoLocation: GeoLocation
    var district: String
    var records: [RecordDTO]

    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "roomId": self.roomId,
            "title": self.title,
            "storeName": self.storeName,
            "difficulty": self.difficulty,
            "genre": self.genre,
            "geoLocation": self.geoLocation.toDictionary,
            "district": self.district,
            "records": self.records.map { $0.toDictionary }
        ]
        return dictionary
    }

    func toDomain() -> Room {
        let genre = Genre(rawValue: self.genre) ?? Genre.all
        let district = District(rawValue: self.district) ?? District.none
        let satisfactionSum = self.records.reduce(.zero, { $0 + $1.satisfaction })
        let avarageSatisfaction = self.records.count == .zero ? .zero : (satisfactionSum / Double(self.records.count)).rounded()
        return Room(roomId: self.roomId,
                    title: self.title,
                    storeName: self.storeName,
                    difficulty: self.difficulty,
                    averageSatisfaction: avarageSatisfaction,
                    genre: genre,
                    geoLocation: self.geoLocation.clLocation,
                    district: district,
                    records: self.records.map({ $0.toDomain() }),
                    distance: .zero)
    }
}
