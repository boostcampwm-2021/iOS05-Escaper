//
//  MapViewModel.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/23.
//

import Foundation

protocol MapViewModelInterface {
    var stores: Observable<[Store]> { get }

    func query(name: String)
}

final class MapViewModel: MapViewModelInterface {
    private let usecase: StoreUseCaseInterface
    private(set) var stores: Observable<[Store]>

    init(usecase: StoreUseCaseInterface) {
        self.usecase = usecase
        self.stores = Observable([])
    }

    func query(name: String) {
        self.usecase.query(name: name) { result in
            switch result {
            case .success(let stores):
                self.stores.value = stores.sorted { $0.distance < $1.distance }
            case .failure(let error):
                print(error)
            }
        }
    }
}
