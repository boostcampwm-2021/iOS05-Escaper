//
//  RoomListRepository.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation

final class RoomListRepository {
    let service: RoomListNetwork

    init(service: RoomListNetwork) {
        self.service = service
    }

    func get(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void) {
        service.get(genre: genre, district: district) { result in
            switch result {
            case .success(let roomDTO):
                completion(.success(roomDTO.map { $0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
