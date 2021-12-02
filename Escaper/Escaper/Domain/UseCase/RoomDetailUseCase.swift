//
//  RoomDetailUseCase.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

protocol RoomDetailUseCaseInterface {
    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void)
    func fetch(userId: String, completion: @escaping (Result<User, Error>) -> Void)
}

final class RoomDetailUseCase: RoomDetailUseCaseInterface {
    private let roomListRepository: RoomListRepositoryInterface
    private let userRepository: UserRepositoryInterface

    init(roomListRepository: RoomListRepositoryInterface, userRepository: UserRepositoryInterface) {
        self.roomListRepository = roomListRepository
        self.userRepository = userRepository
    }

    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        self.roomListRepository.fetch(roomId: roomId) { result in
            switch result {
            case .success(var room):
                room.records = room.records
                    .sorted { $0.escapingTime < $1.escapingTime }
                    .map { $0 }
                completion(.success(room))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetch(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        self.userRepository.fetchUser(userId: userId) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
