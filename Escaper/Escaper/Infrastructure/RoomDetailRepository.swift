//
//  RoomDetailRepository.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

final class RoomDetailRepository: RoomDetailRepositoryInterface {
    private let service: RoomListNetwork & RoomDetailNetwork

    init(service: RoomListNetwork & RoomDetailNetwork) {
        self.service = service
    }

    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        self.service.queryRoom(roomId: roomId) { result in
            switch result {
            case .success(let roomDTO):
                completion(.success(roomDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.service.queryUser(userId: userId) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
