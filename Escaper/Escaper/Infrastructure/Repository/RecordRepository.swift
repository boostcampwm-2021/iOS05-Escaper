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

    func query(userEmail: String, completion: @escaping (Result<[Record], Error>) -> Void) {
        self.service.queryRecord(userEmail: userEmail) { result in
            switch result {
            case .success(let recordDTOs):
                completion(.success(recordDTOs.map({ $0.toDomain() })))
            case .failure(let error):
                print(error)
            }
        }
    }

    func addRecord(_ record: Record) {
        self.service.add(recordDTO: record.toDTO())
    }
}
