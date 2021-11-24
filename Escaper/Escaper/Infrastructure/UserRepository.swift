//
//  UserRepository.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/22.
//

import Foundation

final class UserRepository: UserRepositoryInterface {
    private let service: UserNetwork

    init(service: UserNetwork) {
        self.service = service
    }

    func query(userEmail: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.service.queryUser(email: userEmail) { result in
            switch result {
            case .success(let isOverlaped):
                if isOverlaped {
                    completion(.success(true))
                }
                else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }

    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.service.confirmUser(email: userEmail, password: userPassword) { result in
            switch result {
            case .success(let isOverlaped):
                if isOverlaped {
                    completion(.success(true))
                }
                else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }

    func add(user: User) {
        self.service.addUser(user: user)
    }
}
