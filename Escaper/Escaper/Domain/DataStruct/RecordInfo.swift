//
//  RecordInfo.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

struct RecordInfo {
    var userEmail: String
    var roomId: String
    var satisfaction: Rating
    var isSuccess: Bool
    var time: Int

    func toDTO() -> RecordInfoDTO {
        return RecordInfoDTO(userEmail: self.userEmail,
                                     roomId: self.roomId,
                                     satisfaction: Double(self.satisfaction.rawValue),
                                     isSuccess: self.isSuccess,
                                     time: self.time)
    }
}
