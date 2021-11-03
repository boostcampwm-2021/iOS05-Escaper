//
//  UserRecord.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/03.
//

import Foundation

struct UserRecord: Codable {
    var nickname: String
    var satisfaction: Double
    var playTime: Int

    var toDictionary: [String: Any] {
        let dictionary: [String: Any] = [
            "nickname": self.nickname,
            "satisfaction": self.satisfaction,
            "playTime": self.playTime
        ]

        return dictionary
    }
}
