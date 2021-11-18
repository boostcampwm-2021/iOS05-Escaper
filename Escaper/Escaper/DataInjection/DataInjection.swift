//
//  DataInjection.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/17.
//

import Foundation
import CoreLocation
import Firebase

class DataInjection {
    static let shared = DataInjection()
    private init() {}

    enum LocationCode: Int {
        case hongdae = 1000
        case gangnam = 2000
        case gundae = 3000
        case sinchon = 4000
        case daehakro = 5000
        case gangbuk = 6000
        case sinlim = 7000
        case extra = 8000

        var name: String {
            return String(describing: self)
        }
    }


    func run(jsonFileCode: LocationCode) {
        guard let json = self.readLocalFile(location: jsonFileCode),
              let injectionDTO = self.decode(from: json) else { return }

        var roomId = jsonFileCode.rawValue

        injectionDTO.stores.forEach { storeInjectionDTO in

            var roomIds = [String]()
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")

            let genres = storeInjectionDTO.rooms.map({ Genre(rawValue: $0.genre) }).compactMap({ $0 })
            if genres.isEmpty { return } // 특정 업체가 가지고 있는 방의 장르가 우리가 가지고 있는 장르에 해당하는 것이 하나도 없을 경우 다음 업체를 봐야 함

            geocoder.geocodeAddressString(storeInjectionDTO.address, in: nil, preferredLocale: locale) { placemarks, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let placemark = placemarks?.first else { return }

                let geoLocation = GeoLocation(latitude: (placemark.location?.coordinate.latitude)!, longitude: (placemark.location?.coordinate.longitude)!)
                let district = storeInjectionDTO.address.components(separatedBy: " ")[1]

                storeInjectionDTO.rooms.forEach { room in

                    if Genre(rawValue: room.genre) == nil { return } // 없는 genre의 데이터가 있을 경우 다음 방으로 넘어감

                    roomId += 1
                    roomIds.append("\(roomId)")

                    let roomDTO = RoomDTO(roomId: "\(roomId)",
                            title: room.title,
                            storeName: storeInjectionDTO.storeName,
                            difficulty: room.difficulty,
                            genre: room.genre,
                            geoLocation: geoLocation,
                            district: district,
                            records: [])

                    FirebaseService.shared.addRoom(room: roomDTO)
                }

                let storeDTO = StoreDTO(name: storeInjectionDTO.storeName,
                         homePage: storeInjectionDTO.homepage,
                         telephone: storeInjectionDTO.telephone,
                         address: storeInjectionDTO.address,
                         geoLocation: geoLocation,
                         district: district,
                         roomIds: roomIds)

                FirebaseService.shared.addStore(store: storeDTO)
            }
        }

    }

    private func readLocalFile(location: LocationCode) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: location.name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        return nil
    }

    private func decode(from data: Data) -> InjectionDTO? {
        return try? JSONDecoder().decode(InjectionDTO.self, from: data)
    }
}

extension FirebaseService {
    func addRoom(room: RoomDTO) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let database = Firestore.firestore()
        let path = database.collection(Collection.rooms.value).document("\(room.roomId)")
        path.setData(room.toDictionary())
    }

    func addStore(store: StoreDTO) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let database = Firestore.firestore()
        let path = database.collection(Collection.stores.value).document("\(store.district)_\(store.name)")
        path.setData(store.toDictionary())
    }
}
