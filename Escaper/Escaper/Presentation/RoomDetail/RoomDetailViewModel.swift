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
    func fetch(userId: String, at index: Int)
}

final class DefaultRoomDetailViewModel: RoomDetailViewModelInterface {
    private let usecase: RoomDetailUseCaseInterface
    private(set) var room: Observable<Room?>
    private(set) var users: Observable<[User]>
    private var usersBuffer: [User?]

    init(usecase: RoomDetailUseCaseInterface) {
        self.usecase = usecase
        self.room = Observable(nil)
        self.users = Observable([])
        self.usersBuffer = [nil, nil, nil]
    }

    func fetch(roomId: String) {
        self.usecase.fetch(roomId: roomId) { [weak self] result in
            switch result {
            case .success(let room):
                self?.room.value = room
                for (index, record) in room.records.enumerated() {
                    self?.fetch(userId: record.userEmail, at: index)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetch(userId: String, at index: Int) {
        self.usecase.fetch(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                self?.usersBuffer[index] = user
                if let usersBuffer = self?.usersBuffer.compactMap({ $0 }),
                   usersBuffer.count == self?.room.value?.records.count {
                    self?.users.value = usersBuffer
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
