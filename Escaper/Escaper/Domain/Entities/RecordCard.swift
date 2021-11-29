//
//  Record.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

struct RecordCard: Hashable {
    var username: String
    var createdTime: Date
    var recordImageURLString: String
    var roomTitle: String
    var storeName: String
    var isSuccess: Bool
    var satisfaction: Double
    var difficulty: Int
    var numberOfTotalPlayers: Int
    var rank: Int
    var time: Int

    init(record: Record, room: Room) {
        self.username = Helper.parseUsername(email: record.userEmail) ?? "Unknown"
        self.createdTime = record.createdTime
        self.recordImageURLString = record.imageURLString
        self.roomTitle = room.title
        self.storeName = room.storeName
        self.isSuccess = record.isSuccess
        self.satisfaction = record.satisfaction
        self.difficulty = room.difficulty
        self.numberOfTotalPlayers = room.records.count
        self.rank = Helper.binarySearch(value: record.escapingTime, sortedValues: room.records.map({ $0.escapingTime }).sorted()) ?? room.records.count
        self.time = record.escapingTime
    }

    static func == (lhs: RecordCard, rhs: RecordCard) -> Bool {
        return lhs.username == rhs.username && lhs.storeName == rhs.storeName && lhs.roomTitle == rhs.roomTitle
    }
}
