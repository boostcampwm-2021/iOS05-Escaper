//
//  RoomListUseCase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

protocol RoomListUseCaseInterface {
    func query(district: District, genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void)
    func fetch(name: String, completion: @escaping (Result<[Room], Error>) -> Void)
}

protocol StoreDetailUseCaseInterface {
    func fetch(ids: [String], completion: @escaping (Result<Room, Error>) -> Void)
}

final class RoomListUseCase {
    private let repository: RoomListRepositoryInterface

    init(repository: RoomListRepositoryInterface) {
        self.repository = repository
    }
}

extension RoomListUseCase: RoomListUseCaseInterface {
    func query(district: District, genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.repository.query(genre: genre, district: district) { result in
            switch result {
            case .success(var roomList):
                guard let location = CLLocationManager().location else { return }
                for index in 0..<roomList.count {
                    roomList[index].updateDistance(location.distance(from: roomList[index].geoLocation))
                }
                completion(.success(roomList))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func fetch(name: String, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.repository.fetch(name: name) { result in
            switch result {
            case .success(let rooms):
                completion(.success(rooms))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension RoomListUseCase: StoreDetailUseCaseInterface {
    func fetch(ids: [String], completion: @escaping (Result<Room, Error>) -> Void) {
        ids.forEach { id in
            self.repository.fetch(roomId: id) { result in
                switch result {
                case .success(let room):
                    completion(.success(room))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
