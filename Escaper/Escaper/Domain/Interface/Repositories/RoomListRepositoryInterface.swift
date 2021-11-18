//
//  RoomListRepositoryInterface.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

protocol RoomListRepositroyInterface {
    func query(genre: Genre, district: District, completion: @escaping (Result<[Room], Error>) -> Void)
    func fetch(roomId: String, completion: @escaping (Result<Room, Error>) -> Void)
    func fetch(name: String, completion: @escaping (Result<[Room], Error>) -> Void)
    func updateRecords(to roomId: String, records: [Record])
}
