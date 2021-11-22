//
//  LeaderBoardViewModel.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

protocol LeaderBoardViewModelInterface {
    var users: Observable<[User]> { get }

    func fetch()
}

final class DefaultLeadeBoardViewModel: LeaderBoardViewModelInterface {
    private let usecase: LeaderBoardUseCaseInterface
    private(set) var users: Observable<[User]>

    init(usecase: LeaderBoardUseCaseInterface) {
        self.usecase = usecase
        self.users = Observable([])
    }

    func fetch() {
        self.usecase.fetch { result in
            switch result {
            case .success(let users):
                self.users.value = users.sorted {$0.score > $1.score}
            case .failure(let error):
                print(error)
            }
        }
    }
}
