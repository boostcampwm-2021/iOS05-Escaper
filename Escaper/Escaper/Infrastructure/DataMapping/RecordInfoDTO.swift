//
//  RecordInfoDTO.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

struct RecordInfoDTO: Codable {
    var userEmail: String
    var roomId: String
    var satisfaction: Double
    var isSuccess: Bool
    var time: Int

    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "userEmail": self.userEmail,
            "roomId": self.roomId,
            "satisfaction": self.satisfaction,
            "isSuccess": self.isSuccess,
            "time": self.time
        ]
        return dictionary
    }

    func toDomain() -> RecordInfo {
        return RecordInfo(userEmail: self.userEmail,
                                roomId: self.roomId,
                                satisfaction: Rating(rawValue: Int(self.satisfaction.rounded())) ?? Rating.zero,
                                isSuccess: self.isSuccess,
                                time: self.time)
    }
}
