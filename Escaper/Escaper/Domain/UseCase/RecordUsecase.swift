//
//  RecordUsecase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Foundation

protocol RecordUsecaseInterface {
    func fetchAllRecords(userEmail: String, completion: @escaping (Result<Record, Error>) -> Void)
    func addRecord(imageUrlString: String?, userEmail: String, roomId: String, satisfaction: Rating, isSuccess: Bool, time: Int)
}

class RecordUsecase: RecordUsecaseInterface {
    private let roomRepository: RoomListRepositroyInterface
    private let recordRepository: RecordRepository

    init(roomRepository: RoomListRepositroyInterface, recordRepository: RecordRepository) {
        self.roomRepository = roomRepository
        self.recordRepository = recordRepository
    }

    func fetchAllRecords(userEmail: String, completion: @escaping (Result<Record, Error>) -> Void) {
        self.recordRepository.query(userEmail: userEmail) { result in
            switch result {
            case .success(let recordInfos):
                recordInfos.forEach { recordInfo in
                    self.roomRepository.fetch(roomId: recordInfo.roomId) { result in
                        switch result {
                        case .success(let room):
                            completion(.success(Record(recordInfo: recordInfo, room: room)))
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

    func addRecord(imageUrlString: String?, userEmail: String, roomId: String, satisfaction: Rating, isSuccess: Bool, time: Int) {
        let recordInfo = RecordInfo(imageUrlString: imageUrlString ?? RecordInfo.defaultImageUrlString,
                                    userEmail: userEmail,
                                    roomId: roomId,
                                    satisfaction: satisfaction,
                                    isSuccess: isSuccess,
                                    time: time)
        self.recordRepository.addRecord(recordInfo: recordInfo)
    }
}
