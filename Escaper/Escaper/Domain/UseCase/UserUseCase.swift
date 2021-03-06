//
//  UserUseCase.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/22.
//

import Foundation

protocol UserUseCaseInterface {
    func query(userEmail: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<User, UserError>) -> Void)
    func add(user: User)
}

protocol UpdateUserUscCaseInterface {
    func updateScore(userEmail: String, score: Int)
}

final class UserUseCase: UserUseCaseInterface {
    private let repository: UserRepositoryInterface

    init(userRepository: UserRepositoryInterface) {
        self.repository = userRepository
    }

    func query(userEmail: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.repository.query(userEmail: userEmail) { result in
            switch result {
            case .success(let isOverlaped):
                if isOverlaped {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<User, UserError>) -> Void) {
        self.repository.confirm(userEmail: userEmail, userPassword: userPassword) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(.notExist):
                completion(.failure(.notExist))
            case .failure(.networkUnconneted):
                completion(.failure(.networkUnconneted))
            }
        }
    }

    func add(user: User) {
        self.repository.add(user: user)
    }
}

extension UserUseCase: UpdateUserUscCaseInterface {
    func updateScore(userEmail: String, score: Int) {
//        self.repository.updateScore(userEmail: userEmail, score: score)
        self.repository.update(score: score, belongsTo: userEmail)
    }
}
