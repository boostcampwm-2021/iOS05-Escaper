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

class DefaultRoomListUseCase: RoomListUseCaseInterface {
    let repository: RoomListRepositroyInterface

    init(repository: RoomListRepositroyInterface) {
        self.repository = repository
    }

    func query(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.fetchCurrentDistrict(genre: genre, completion: completion)
    }

    private func fetchCurrentDistrict(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        let locationManager: CLLocationManager = {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            return manager
        }()
        guard let location = locationManager.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) {  placeMarks, _ in
            guard let address: [CLPlacemark] = placeMarks,
                  let locality = address.last?.locality,
                  let district = District.init(rawValue: locality) else { return }
            self.repository.query(genre: genre, district: district, completion: completion)
        }
    }
}
