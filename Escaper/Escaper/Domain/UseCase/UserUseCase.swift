//
//  UserUseCase.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/22.
//

import Foundation

final class UserUseCase {
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
                }
                else {
                    completion(.success(false))
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        self.repository.confirm(userEmail: userEmail, userPassword: userPassword) { result in
            switch result {
            case .success(let isOverlaped):
                if isOverlaped {
                    completion(.success(true))
                }
                else {
                    completion(.success(false))
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func add(user: User) {
        self.repository.add(user: user)
    }
}
