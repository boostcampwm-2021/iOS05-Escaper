//
//  StoreRepository.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/23.
//

import Foundation

final class StoreRepository: StoreRepositoryInterface {
    private let service: StoreNetwork

    init(service: StoreNetwork) {
        self.service = service
    }

    func query(name: String, completion: @escaping (Result<[Store], Error>) -> Void) {
        self.service.queryStore(name: name) { result in
            switch result {
            case .success(let storeDTOs):
                completion(.success(storeDTOs.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
