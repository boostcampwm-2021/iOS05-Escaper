//
//  RecordUsecase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Foundation

protocol RecordUsecaseInterface {
    func fetchAllRecords(userEmail: String, completion: @escaping (Result<RecordCard, Error>) -> Void)
    func addRecord(imageURLString: String, userEmail: String, roomId: String, satisfaction: Double, isSuccess: Bool, time: Int, records: [Record])
}

final class RecordUsecase: RecordUsecaseInterface {
    private let roomRepository: RoomListRepositoryInterface
    private let recordRepository: RecordRepository

    init(roomRepository: RoomListRepositoryInterface, recordRepository: RecordRepository) {
        self.roomRepository = roomRepository
        self.recordRepository = recordRepository
    }

    func fetchAllRecords(userEmail: String, completion: @escaping (Result<RecordCard, Error>) -> Void) {
        self.recordRepository.query(userEmail: userEmail) { result in
            switch result {
            case .success(let records):
                records.forEach { record in
                    self.roomRepository.fetch(roomId: record.roomId) { result in
                        switch result {
                        case .success(let room):
                            completion(.success(RecordCard(record: record, room: room)))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func addRecord(imageURLString: String, userEmail: String, roomId: String, satisfaction: Double, isSuccess: Bool, time: Int, records: [Record]) {
        let record = Record(createdTime: Date(),
                            userEmail: userEmail,
                            roomId: roomId,
                            isSuccess: isSuccess,
                            imageURLString: imageURLString,
                            satisfaction: satisfaction,
                            escapingTime: time)
        self.recordRepository.addRecord(record)
        self.roomRepository.updateRecords(to: roomId, records: records + [record])
    }
}
