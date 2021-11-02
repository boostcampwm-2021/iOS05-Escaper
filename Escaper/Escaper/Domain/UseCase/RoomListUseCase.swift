//
//  RoomListUseCase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

protocol RoomListUseCaseInterface {
    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void)
}

class DefaultRoomListUseCase: RoomListUseCaseInterface {
    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {

    }

}
