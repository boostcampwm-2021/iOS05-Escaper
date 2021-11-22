//
//  LeaderBoardViewModel.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

protocol LeaderBoardViewModelInterface {
    var users: [User] { get }
    var topThreeUser: [User] { get }
    var topTenUser: [User] { get }
    var count: Int { get }
    func fetch()
}

final class DefaultLeadeBoardViewModel: LeaderBoardViewModelInterface {
    private let usecase: LeaderBoardUseCaseInterface
    private(set) var users: [User]
    var topThreeUser: [User] {
        return self.users.prefix(3).map {$0}
    }
    var topTenUser: [User] {
        return self.users.prefix(10).map {$0}
    }
    var count: Int {
        return self.users.count
    }

    init(usecase: LeaderBoardUseCaseInterface) {
        self.usecase = usecase
        self.users = []
    }

    func fetch() {
        self.usecase.fetch { result in
            switch result {
            case .success(let users):
                self.users = users.sorted {$0.score < $1.score}
            case .failure(let error):
                print(error)
            }
        }
    }
}
