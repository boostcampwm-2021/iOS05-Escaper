//
//  RoomListRepository.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation

final class RoomListRepository: RoomListRepositroyInterface {
    private let service: RoomListNetwork

    init(service: RoomListNetwork) {
        self.service = service
    }

    func query(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.service.query(genre: genre, district: district) { result in
            switch result {
            case .success(let roomDTOList):
                completion(.success(roomDTOList.map { $0.toDomain()}))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        self.service.query(roomId: roomId) { result in
            switch result {
            case .success(let roomDTO):
                completion(.success(roomDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch(name: String, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.service.query(name: name) { result in
            switch result {
            case .success(let roomDTOs):
                completion(.success(roomDTOs.map({ $0.toDomain() })))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
