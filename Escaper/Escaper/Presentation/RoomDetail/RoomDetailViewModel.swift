//
//  RoomDetailViewModel.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

protocol RoomDetailViewModelInterface {
    var room: Observable<Room?> { get }

    func fetch(roomID: String)
}

final class DefaultRoomDetailViewModel: RoomDetailViewModelInterface {
    private let usecase: RoomDetailUseCaseInterface
    private(set) var room: Observable<Room?>

    init(usecase: RoomDetailUseCaseInterface) {
        self.usecase = usecase
        self.room = Observable(nil)
    }

    func fetch(roomID: String) {
        self.usecase.fetch(roomId: roomID) { [weak self] result in
            switch result {
            case .success(let room):
                self?.room.value = room
            case .failure(let error):
                print(error)
            }
        }
    }
}
