//
//  StoreDetailViewModel.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import Foundation

protocol StoreDetailViewModelInterface {
    var rooms: Observable<[Room]> { get }

    func fetchRooms(ids: [String])
}

final class StoreDetailViewModel: StoreDetailViewModelInterface {
    private let usecase: StoreDetailUseCaseInterface
    private(set) var rooms: Observable<[Room]>

    init(usecase: StoreDetailUseCaseInterface) {
        self.usecase = usecase
        self.rooms = Observable([])
    }

    func fetchRooms(ids: [String]) {
        self.usecase.fetch(ids: ids) { [weak self] result in
            switch result {
            case .success(let room):
                self?.rooms.value.append(room)
            case .failure(let error):
                print(error)
            }
        }
    }
}
