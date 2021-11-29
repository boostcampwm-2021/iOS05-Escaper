//
//  RoomDetailViewModel.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/27.
//

import Foundation

protocol RoomDetailViewModelInterface {
    var room: Observable<Room?> { get }
    var users: Observable<[User]> { get }

    func fetch(roomId: String)
    func fetch(userId: String)
}

final class DefaultRoomDetailViewModel: RoomDetailViewModelInterface {
    private let usecase: RoomDetailUseCaseInterface
    private(set) var room: Observable<Room?>
    private(set) var users: Observable<[User]>

    init(usecase: RoomDetailUseCaseInterface) {
        self.usecase = usecase
        self.room = Observable(nil)
        self.users = Observable([])
    }

    func fetch(roomId: String) {
        self.usecase.fetch(roomId: roomId) { [weak self] result in
            switch result {
            case .success(let room):
                self?.room.value = room
                self?.room.value?.records.forEach {
                    self?.fetch(userId: $0.userEmail)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetch(userId: String) {
        self.usecase.fetch(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.users.value.append(user)
            case .failure(let error):
                print(error)
            }
        }
    }
}
