//
//  RoomListRepositoryInterface.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

protocol RoomListRepositroyInterface {
    func query(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void)
    func fetch(by roomId: String, completion: @escaping (Result<Room, Error>) -> Void)
}
