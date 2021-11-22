//
//  LeaderBoardRepository.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

final class LeaderBoardRepository: LeaderBoardRepositoryInterface {
    private let service: LeaderBoardNetwork

    init(service: LeaderBoardNetwork) {
        self.service = service
    }

    func fetch(completion: @escaping (Result<[User], Error>) -> Void) {
        self.service.queryUser { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
