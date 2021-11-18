//
//  RecordInfo.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

struct Record {
    var createdTime: Date
    var userEmail: String
    var roomId: String
    var isSuccess: Bool
    var imageURLString: String
    var satisfaction: Double
    var escapingTime: Int

    func toDTO() -> RecordDTO {
        return RecordDTO(createdTime: self.createdTime,
                         userEmail: self.userEmail,
                         roomId: self.roomId,
                         isSuccess: self.isSuccess,
                         imageURLString: self.imageURLString,
                         satisfaction: self.satisfaction,
                         escapingTime: self.escapingTime)
    }
}
