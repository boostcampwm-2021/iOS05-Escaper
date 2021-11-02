//
//  RoomListViewModel.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

protocol RoomListViewModelInterface {
    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void)
}

class DefaultRoomListViewModel: RoomListViewModelInterface {
    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        
    }
    
}
