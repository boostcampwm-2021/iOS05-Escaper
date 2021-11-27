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

protocol LeaderBoardNetwork: AnyObject {
    func queryUser(completion: @escaping (Result<[User], Error>) -> Void)
}

protocol StoreNetwork: AnyObject {
    func queryStore(name: String, completion: @escaping (Result<[StoreDTO], Error>) -> Void)
}

protocol UserNetwork: AnyObject {
    func queryUser(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func confirmUser(email: String, password: String, completion: @escaping (Result<User, UserError>) -> Void)
    func addUser(user: User)
}

protocol FeedbackNetwork: AnyObject {
    func addFeedback(feedbackDTO: FeedbackDTO)
}

final class FirebaseService: RoomListNetwork {
    enum Collection: String {
        case users
        case rooms
        case records
        case stores
        case feedbacks

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
                case .success(let roomDTO):
                    if let roomDTO = roomDTO {
                        completion(.success(roomDTO))
                    }
                case .failure(let error):
                    completion(.failure(error))

                }
            }
    }

    func queryRoom(name: String, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        database.collection(Collection.rooms.value)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let result = Result {
                    try documents.map { try $0.data(as: RoomDTO.self) }
                    .compactMap { $0 }
                    .filter { $0.title.hasPrefix(name) }
                }
                switch result {
                case .success(let recordDTOs):
                    completion(.success(recordDTOs.filter { $0.title.hasPrefix(name) }
                                            .sorted { $0.title < $1.title }))
                case .failure(let error):
                    completion(.failure(error))
                }
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
                let result = Result {
                    try documents.map { try $0.data(as: RecordDTO.self) }.compactMap { $0 }
                }
                switch result {
                case .success(let recordDTOs):
                    completion(.success(recordDTOs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func addRecord(recordDTO: RecordDTO) {
        let path = self.database.collection(Collection.records.value).document("\(recordDTO.userEmail)_\(recordDTO.roomId)")
        path.setData(recordDTO.toDictionary())
    }
}

extension FirebaseService: LeaderBoardNetwork {
    func queryUser(completion: @escaping (Result<[User], Error>) -> Void) {
        self.database.collection(Collection.users.value)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let result = Result {
                    try documents.map { try $0.data(as: User.self) }.compactMap { $0 }
                }
                switch result {
                case .success(let users):
                    completion(.success(users))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

private extension FirebaseService {
    func query(by genre: Genre, district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        self.database.collection(Collection.rooms.value)
            .whereField("genre", isEqualTo: genre.name)
            .whereField("district", isEqualTo: district.name)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let result = Result {
                    try documents.map { try $0.data(as: RoomDTO.self) }.compactMap { $0 }
                }
                switch result {
                case .success(let roomDTOs):
                    completion(.success(roomDTOs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func query(district: District, completion: @escaping (Result<[RoomDTO], Error>) -> Void) {
        self.database.collection(Collection.rooms.value)
            .whereField("district", isEqualTo: district.name)
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let result = Result {
                    try documents.map { try $0.data(as: RoomDTO.self) }.compactMap { $0 }
                }
                switch result {
                case .success(let roomDTOs):
                    completion(.success(roomDTOs))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

extension FirebaseService: StoreNetwork {
    func queryStore(name: String, completion: @escaping (Result<[StoreDTO], Error>) -> Void) {
        database.collection(Collection.stores.value)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                let result = Result {
                    try documents.map { try $0.data(as: StoreDTO.self) }.compactMap { $0 }
                }
                switch result {
                case .success(let storeDTOs):
                    completion(.success(storeDTOs.filter { $0.name.contains(name) }))
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
    }
}

extension FirebaseService: UserNetwork {
    func queryUser(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.database.collection(Collection.users.value)
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, _ in
                if snapshot?.documents.isEmpty == true {
                    completion(.success(false))
                    return
                }
                guard let document = snapshot?.documents.first else { return }
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success:
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func confirmUser(email: String, password: String, completion: @escaping (Result<User, UserError>) -> Void) {
        self.database.collection(Collection.users.value)
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password)
            .getDocuments { snapshot, _  in
                if snapshot?.documents.isEmpty == true {
                    completion(.failure(.notExist))
                    return
                }
                guard let document = snapshot?.documents.first else { return }
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        completion(.success(user))
                    }
                case .failure:
                    completion(.failure(.networkUnconneted))
                }
            }
    }

    func addUser(user: User) {
        let path = self.database.collection(Collection.users.value).document("\(user.name)")
        path.setData(user.toDictionary())
    }
}

extension FirebaseService: FeedbackNetwork {
    func addFeedback(feedbackDTO: FeedbackDTO) {
        let path = self.database.collection(Collection.feedbacks.value).document()
        path.setData(feedbackDTO.toDictionary())
    }
}
