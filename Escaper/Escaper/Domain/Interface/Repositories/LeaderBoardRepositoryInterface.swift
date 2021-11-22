//
//  LeaderBoardRepositoryInterface.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/22.
//

import Foundation

protocol LeaderBoardRepositoryInterface {
    func fetch(completion: @escaping  (Result<[User], Error>) -> Void)
}
