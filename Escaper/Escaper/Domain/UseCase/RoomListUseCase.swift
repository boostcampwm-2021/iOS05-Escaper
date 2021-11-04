//
//  RoomListUseCase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

protocol RoomListUseCaseInterface {
    func query(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void)
}

class RoomListUseCase: RoomListUseCaseInterface {
    private let repository: RoomListRepositroyInterface
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    init(repository: RoomListRepositroyInterface) {
        self.repository = repository
    }

    func query(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.fetchCurrentDistrict(genre: genre, completion: completion)
    }

    private func fetchCurrentDistrict(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        guard let location = self.locationManager.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) {  placeMarks, _ in
            guard let address: [CLPlacemark] = placeMarks,
                  let locality = address.last?.locality,
                  let district = District.init(rawValue: locality) else { return }
            self.repository.query(genre: genre, district: district) { result in
                switch result {
                case .success(var roomList):
                    for index in 0..<roomList.count {
                        roomList[index].updateDistance(location.distance(from: roomList[index].geoLocation))
                    }
                    completion(.success(roomList))
                case .failure(let err):
                    completion(.failure(err))
                }
            }
        }
    }
}
