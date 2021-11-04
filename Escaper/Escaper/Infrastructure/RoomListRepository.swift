//
//  RoomListRepository.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation

protocol RoomListRepositroyInterface {
    func query(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void)
}

final class RoomListRepository: RoomListRepositroyInterface {
    let service: RoomListNetwork

    init(service: RoomListNetwork) {
        self.service = service
    }

    func query(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void) {
        service.query(genre: genre, district: district) { result in
            switch result {
            case .success(let roomDTOList):
                completion(.success(roomDTOList.map { $0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
