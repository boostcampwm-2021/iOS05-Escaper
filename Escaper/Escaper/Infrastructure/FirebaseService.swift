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
}

final class FirebaseService: RoomListNetwork {
    static let shared = FirebaseService()

    private let database: Firestore

    private init() {
        FirebaseApp.configure()
        self.database = Firestore.firestore()
    }

    func query(genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        database.collection("rooms")
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

    func addRoom(_ room: RoomDTO) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let database = Firestore.firestore()
        let path = database.collection("rooms").document(room.name)
        path.setData(room.toDictionary())
    }
}
