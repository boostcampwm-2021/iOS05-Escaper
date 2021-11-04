//
//  RoomListUseCase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation
import CoreLocation

protocol RoomListUseCaseInterface {
    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void)
}

class DefaultRoomListUseCase: RoomListUseCaseInterface {
    let repository: RoomListRepository

    init(repository: RoomListRepository) {
        self.repository = repository
    }

    func fetch(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        self.fetchCurrentDistrict(genre: genre, completion: completion)
    }

    private func fetchCurrentDistrict(genre: Genre, completion: @escaping (Result<[Room], Error>) -> Void) {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        guard let location = locationManager.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) {  placeMarks, _ in
            guard let address: [CLPlacemark] = placeMarks,
                  let locality = address.last?.locality,
                  let district = District.init(rawValue: locality) else { return }

            self.repository.get(genre: genre, district: district, completion: completion)
        }

    }
}
