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
    func query(genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void)
    func query(roomId: String, completion: @escaping (Result<RoomDTO, Error>) -> Void)
    func query(name: String, completion: @escaping (Result<[RoomDTO], Error>) -> Void)
}

protocol RecordNetwork: AnyObject {
    func query(userEmail: String, completion: @escaping (Result<[RecordInfoDTO], Error>) -> Void)
    func addRecord(recordInfoDTO: RecordInfoDTO)
}

final class FirebaseService: RoomListNetwork {
    enum Collection: String {
        case rooms
        case records

        var value: String {
            return self.rawValue
        }
    }

    static let shared = FirebaseService()

    private let database: Firestore

    private init() {
        self.database = Firestore.firestore()
    }

    func query(genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        database.collection(Collection.rooms.value)
            .whereField("genres", arrayContains: genre.name)
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

    func query(roomId: String, completion: @escaping (Result<RoomDTO, Error>) -> Void) {
        database.collection(Collection.rooms.value)
            .document(roomId)
            .getDocument { snapshot, error in
                let result = Result {
                    try snapshot?.data(as: RoomDTO.self)
                }
                switch result {
                case .success(let roomDTO):
                    guard let roomDTO = roomDTO else { return }
                    completion(.success(roomDTO))
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
    }

    func query(name: String, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        database.collection(Collection.rooms.value)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                var roomList = [RoomDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RoomDTO.self)
                    }
                    switch result {
                    case .success(let room):
                        if let room = room,
                           room.name.hasPrefix(name) {
                            roomList.append(room)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(Result.success(roomList.sorted(by: {$0.name < $1.name })))
            }
    }

    func addRoom(identifier: Int, _ room: RoomDTO) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let database = Firestore.firestore()
        let path = database.collection(Collection.rooms.value).document("\(identifier)")
        path.setData(room.toDictionary())
    }
}

extension FirebaseService: RecordNetwork {
    func query(userEmail: String, completion: @escaping (Result<[RecordInfoDTO], Error>) -> Void) {
        database.collection(Collection.records.value)
            .whereField("userEmail", isEqualTo: userEmail)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                var recordInfoDTOList = [RecordInfoDTO]()
                for document in documents {
                    let result = Result {
                        try document.data(as: RecordInfoDTO.self)
                    }
                    switch result {
                    case .success(let recordInfoDTO):
                        if let recordInfoDTO = recordInfoDTO {
                            recordInfoDTOList.append(recordInfoDTO)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                completion(Result.success(recordInfoDTOList))
            }
    }

    func addRecord(recordInfoDTO: RecordInfoDTO) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let database = Firestore.firestore()
        let path = database.collection(Collection.records.value).document()
        path.setData(recordInfoDTO.toDictionary())
    }
}
