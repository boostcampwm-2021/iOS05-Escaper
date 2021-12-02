//
//  RoomDetailRepositoryInterface.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

protocol RoomDetailRepositoryInterface {
    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void)
    func fetch(userId: String, completion: @escaping (Result<User, Error>) -> Void)
}
