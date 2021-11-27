//
//  RoomDetailUseCase.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

protocol RoomDetailUseCaseInterface {
    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void)
}

final class RoomDetailUseCase: RoomDetailUseCaseInterface {
    private let repository: RoomDetailRepositoryInterface

    init(repository: RoomDetailRepositoryInterface) {
        self.repository = repository
    }

    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        self.repository.fetch(roomId: roomId) { result in
            switch result {
            case .success(let room):
                completion(.success(room))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
