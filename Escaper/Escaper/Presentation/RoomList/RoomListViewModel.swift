//
//  RoomListViewModel.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

protocol RoomListViewModelInterface {
    var rooms: Observable<[Room]> { get }

    func fetch(district: District, genre: Genre, sortingOption: SortingOption)
    func sort(option: SortingOption)
}

final class DefaultRoomListViewModel: RoomListViewModelInterface {
    private let usecase: RoomListUseCaseInterface
    private(set) var rooms: Observable<[Room]>

    init(usecase: RoomListUseCaseInterface) {
        self.usecase = usecase
        self.rooms = Observable([])
    }

    func fetch(district: District, genre: Genre, sortingOption: SortingOption) {
        self.usecase.query(district: district, genre: genre) { [weak self] result in
            guard let self = self else { return }
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
            return rooms.sorted(by: { $0.averageSatisfaction > $1.averageSatisfaction })
        case .difficulty:
            return rooms.sorted(by: { $0.difficulty > $1.difficulty })
        case .distance:
            return rooms.sorted(by: { $0.distance < $1.distance })
        }
    }
}
