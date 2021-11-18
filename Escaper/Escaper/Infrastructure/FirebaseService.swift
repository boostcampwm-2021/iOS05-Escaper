//
//  FirebaseService.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/04.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol RoomListNetwork: AnyObject {
    func queryRoom(genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void)
    func queryRoom(roomId: String, completion: @escaping (Result<RoomDTO, Error>) -> Void)
    func queryRoom(name: String, completion: @escaping (Result<[RoomDTO], Error>) -> Void)
    func updateRecord(roomId: String, records: [RecordDTO])
}

protocol RecordNetwork: AnyObject {
    func queryRecord(userEmail: String, completion: @escaping (Result<[RecordDTO], Error>) -> Void)
    func addRecord(recordDTO: RecordDTO)
}

final class FirebaseService: RoomListNetwork {
    enum Collection: String {
        case users
        case rooms
        case records
        case stores

        var value: String {
            return self.rawValue
        }
    }

    static let shared = FirebaseService()

    private let database: Firestore

    private init() {
        self.database = Firestore.firestore()
    }

    func queryRoom(genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        switch genre {
        case .all:
            self.query(district: district, completion: completion)
        default:
            self.query(by: genre, district: district, completion: completion)
        }
    }

    func queryRoom(roomId: String, completion: @escaping (Result<RoomDTO, Error>) -> Void) {
        self.database.collection(Collection.rooms.value)
            .whereField("roomId", isEqualTo: roomId)
            .getDocuments { snapshot, _ in
                guard let document = snapshot?.documents.first else { return }
                let result = Result {
                    try document.data(as: RoomDTO.self)
                }
                switch result {
                case .success(let room):
                    if let room = room {
                        completion(.success(room))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
    }

    func queryRoom(name: String, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        database.collection(Collection.rooms.value)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                var roomDTOs = [RoomDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RoomDTO.self)
                    }
                    switch result {
                    case .success(let roomDTO):
                        if let roomDTO = roomDTO,
                           roomDTO.title.hasPrefix(name) {
                            roomDTOs.append(roomDTO)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(Result.success(roomDTOs.sorted(by: {$0.title < $1.title })))
            }
    }

    func updateRecord(roomId: String, records: [RecordDTO]) {
        let path = self.database.collection(Collection.rooms.value).document(roomId)
        path.updateData([
            "records": records.map({ $0.toDictionary() })
        ])
    }
}

extension FirebaseService: RecordNetwork {
    func queryRecord(userEmail: String, completion: @escaping (Result<[RecordDTO], Error>) -> Void) {
        database.collection(Collection.records.value)
            .whereField("userEmail", isEqualTo: userEmail)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                var recordDTOs = [RecordDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RecordDTO.self)
                    }
                    switch result {
                    case .success(let recordDTO):
                        if let recordDTO = recordDTO {
                            recordDTOs.append(recordDTO)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(.success(recordDTOs))
            }
    }

    func addRecord(recordDTO: RecordDTO) {
        let path = self.database.collection(Collection.records.value).document("\(recordDTO.userEmail)_\(recordDTO.roomId)")
        path.setData(recordDTO.toDictionary())
    }
}


private extension FirebaseService {
    func query(by genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        self.database.collection(Collection.rooms.value)
            .whereField("genre", isEqualTo: genre.name)
            .whereField("district", isEqualTo: district.name)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                var roomList = [RoomDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RoomDTO.self)
                    }
                    switch result {
                    case .success(let room):
                        if let room = room {
                            roomList.append(room)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(Result.success(roomList))
            }
    }

    func query(district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        self.database.collection(Collection.rooms.value)
            .whereField("district", isEqualTo: district.name)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                var roomList = [RoomDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RoomDTO.self)
                    }
                    switch result {
                    case .success(let room):
                        if let room = room {
                            roomList.append(room)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(Result.success(roomList))
            }
    }
}
