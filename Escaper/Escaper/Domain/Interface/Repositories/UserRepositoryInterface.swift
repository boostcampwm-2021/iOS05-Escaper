//
//  UserRepositoryInterface.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/22.
//

import Foundation

protocol UserRepositoryInterface {
    func query(userEmail: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func confirm(userEmail: String, userPassword: String, completion: @escaping (Result<User, UserError>) -> Void)
    func fetchUser(userId: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchAllUser(completion: @escaping (Result<[User], Error>) -> Void)
    func update(score: Int, belongsTo userEmail: String)
    func add(user: User)
}
