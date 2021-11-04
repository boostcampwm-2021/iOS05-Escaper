//
//  RoomListViewModel.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

protocol RoomListViewModelInterface {
    var rooms: Observable<[Room]> { get }

    func fetch(genre: Genre, sortingOption: SortingOption)
    func sort(option: SortingOption)
}

class DefaultRoomListViewModel: RoomListViewModelInterface {
    private let usecase: RoomListUseCaseInterface
    private(set) var rooms: Observable<[Room]>

    init(usecase: RoomListUseCaseInterface) {
        self.usecase = usecase
        self.rooms = Observable([])
    }

    func fetch(genre: Genre, sortingOption: SortingOption) {
        self.usecase.query(genre: genre) { result in
            switch result {
            case .success(let rooms):
                self.rooms.value = self.sort(rooms: rooms, by: sortingOption)
            case .failure(let error):
                print(error)
            }
        }
    }

    func sort(option: SortingOption) {
        self.rooms.value = self.sort(rooms: self.rooms.value, by: option)
    }
}

private extension DefaultRoomListViewModel {
    func sort(rooms: [Room], by option: SortingOption) -> [Room] {
        switch option {
        case .satisfaction:
            return rooms.sorted(by: { $0.satisfaction.value > $1.satisfaction.value })
        case .level:
            return rooms.sorted(by: { $0.level.value > $1.level.value })
        case .distance:
            return rooms.sorted(by: { $0.distance < $1.distance })
        }
    }
}
