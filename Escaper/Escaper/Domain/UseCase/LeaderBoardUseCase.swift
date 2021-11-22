//
//  LeaderBoardUseCase.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

protocol LeaderBoardUseCaseInterface {
    func fetch(completion: @escaping (Result<[User], Error>) -> Void)
}

final class LeaderBoardUseCase: LeaderBoardUseCaseInterface {
    private let repository: LeaderBoardRepositoryInterface

    init(repository: LeaderBoardRepositoryInterface) {
        self.repository = repository
    }

    func fetch(completion: @escaping (Result<[User], Error>) -> Void) {
        self.repository.fetch { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
