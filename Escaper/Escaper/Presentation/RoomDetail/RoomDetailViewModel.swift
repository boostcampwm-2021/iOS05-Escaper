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
}

final class DefaultRoomDetailViewModel: RoomDetailViewModelInterface {
    private let usecase: RoomDetailUseCaseInterface
    private var numberOfRank = 0
    private(set) var room: Observable<Room?>
    private(set) var users: Observable<[User]>
    private var usersBuffer: [User?] {
        didSet {
            let fetchedUsers = self.usersBuffer.compactMap { $0 }
            if fetchedUsers.count == self.numberOfRank {
                self.users.value = fetchedUsers
            }
        }
    }

    init(usecase: RoomDetailUseCaseInterface) {
        self.usecase = usecase
        self.room = Observable(nil)
        self.users = Observable([])
        self.usersBuffer = []
    }

    func fetch(roomId: String) {
        self.usecase.fetch(roomId: roomId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(var room):
                self.numberOfRank = room.records.count > 5 ? 5 : room.records.count
                self.usersBuffer = Array.init(repeating: nil, count: self.numberOfRank)
                room.records = room.records.prefix(self.numberOfRank).map { $0 }
                self.room.value = room
                for (index, record) in room.records.enumerated() {
                    self.fetch(userId: record.userEmail, at: index)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension DefaultRoomDetailViewModel {
    func fetch(userId: String, at index: Int) {
        self.usecase.fetch(userId: userId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.usersBuffer[index] = user
            case .failure(let error):
                print(error)
            }
        }
    }
}
