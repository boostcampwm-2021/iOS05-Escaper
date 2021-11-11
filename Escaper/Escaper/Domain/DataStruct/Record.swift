//
//  Record.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

struct Record {
    var userEmail: String
    var roomName: String
    var storeName: String
    var isSuccess: Bool
    var satisfaction: Rating
    var difficulty: Rating
    var numberOfTotalPlayers: Int
    var rank: Int
    var time: Int

    init(recordInfo: RecordInfo, room: Room) {
        self.userEmail = recordInfo.userEmail
        self.roomName = room.name
        self.storeName = room.storeName
        self.isSuccess = recordInfo.isSuccess
        self.satisfaction = recordInfo.satisfaction
        self.difficulty = room.level
        self.numberOfTotalPlayers = room.userRecords.count
        self.rank = Self.calculateRank(username: self.userEmail, time: recordInfo.time, allRecords: room.userRecords) ?? 0
        self.time = recordInfo.time
    }
}

private extension Record {
    static func calculateRank(username: String, time: Int, allRecords: [UserRecord]) -> Int? {
        let playerRecord = UserRecord(nickname: username, satisfaction: .zero, playTime: time)
        var allPlayerRecords = allRecords + [playerRecord]
        allPlayerRecords.sort { $0.playTime < $1.playTime }
        return allPlayerRecords.firstIndex { $0.nickname == username }
    }
}
