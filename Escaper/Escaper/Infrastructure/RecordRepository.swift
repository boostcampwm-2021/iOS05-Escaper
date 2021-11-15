//
//  RecordRepository.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

final class RecordRepository: RecordRepositoryInterface {
    private let service: RecordNetwork

    init(service: RecordNetwork) {
        self.service = service
    }

    func query(userEmail: String, completion: @escaping (Result<[RecordInfo], Error>) -> Void) {
        self.service.query(userEmail: userEmail) { result in
            switch result {
            case .success(let recordResponseDTOs):
                completion(.success(recordResponseDTOs.map({ $0.toDomain() })))
            case .failure(let error):
                print(error)
            }
        }
    }

    func addRecord(recordInfo: RecordInfo) {
        self.service.addRecord(recordInfoDTO: recordInfo.toDTO())
    }
}
