//
//  StoreDTO.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/17.
//

import Foundation

struct StoreDTO: Codable {
    var name: String
    var homePage: String
    var telephone: String
    var address: String
    var region: String
    var geoLocation: GeoLocation
    var district: String
    var roomIds: [String]

    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "name": self.name,
            "homePage": self.homePage,
            "telephone": self.telephone,
            "address": self.address,
            "region": self.region,
            "geoLocation": self.geoLocation.toDictionary,
            "district": self.district,
            "roomIds": self.roomIds
        ]
        return dictionary
    }

    func toDomain() -> Store {
        let district = District(rawValue: self.district) ?? District.none
        let region = StoreRegion(rawValue: self.region) ?? StoreRegion.extra
        return Store(name: self.name,
                     homePage: self.homePage,
                     telephone: self.telephone,
                     address: self.address,
                     region: region,
                     geoLocation: self.geoLocation.clLocation,
                     district: district,
                     roomIds: self.roomIds)
    }
}
