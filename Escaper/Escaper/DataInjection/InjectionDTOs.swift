//
//  InjectionDTOs.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/17.
//

import Foundation

struct InjectionDTO: Codable {
    let stores: [StoreInjectionDTO]
}

struct StoreInjectionDTO: Codable {
    let storeName, telephone: String
    let homepage: String
    let address: String
    let rooms: [RoomInjectionDTO]
}

struct RoomInjectionDTO: Codable {
    let title, genre: String
    let difficulty: Int
}
