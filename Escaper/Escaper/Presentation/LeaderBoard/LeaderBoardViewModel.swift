//
//  LeaderBoardViewModel.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

protocol LeaderBoardViewModelInterface {
    var users: [User] { get }
}

final class DefaultLeadeBoardViewModel: LeaderBoardViewModelInterface {
    private let usecase: LeaderBoardUseCaseInterface
    private(set) var users: [User]

    init(usecase: LeaderBoardUseCaseInterface) {
        self.usecase = usecase
        self.users = []
    }

    func fetch() {
        self.usecase.fetch { result in
            switch result {
            case .success(let users):
                self.users = users.sorted {$0.score < $1.score}
                .prefix(10)
                .map {$0}
            case .failure(let error):
                print(error)
            }
        }
    }
}
