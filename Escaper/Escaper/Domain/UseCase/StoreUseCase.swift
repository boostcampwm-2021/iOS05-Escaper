//
//  StoreUseCase.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/23.
//

import Foundation
import CoreLocation

protocol StoreUseCaseInterface {
    func query(name: String, completion: @escaping (Result<[Store], Error>) -> Void)
}

final class StoreUseCase: StoreUseCaseInterface {
    private let repository: StoreRepositoryInterface

    init(repository: StoreRepositoryInterface) {
        self.repository = repository
    }

    func query(name: String, completion: @escaping (Result<[Store], Error>) -> Void) {
        self.repository.query(name: name) { result in
            switch result {
            case .success(var storeList):
                guard let location = CLLocationManager().location else { return }
                for index in 0..<storeList.count {
                    storeList[index].updateDistance(location.distance(from: storeList[index].geoLocation))
                }
                completion(.success(storeList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
