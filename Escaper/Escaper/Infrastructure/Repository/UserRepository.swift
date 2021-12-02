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
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                completion(.failure(error))
                print(error)
            }
        }
    }

    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<User, UserError>) -> Void) {
        self.service.confirmUser(email: userEmail, password: userPassword) { result in
            switch result {
            case .success(let userDTO):
                completion(.success(userDTO.toDomain()))
            case .failure(.notExist):
                completion(.failure(.notExist))
            case .failure(.networkUnconneted):
                completion(.failure(.networkUnconneted))
            }
        }
    }

    func add(user: User) {
        self.service.add(userDTO: user.toDTO())
    }

    func update(score: Int, belongsTo userEmail: String) {
        self.service.update(score: score, belongsTo: userEmail)
    }
}
