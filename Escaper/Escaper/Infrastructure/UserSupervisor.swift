//
//  UserSupervisor.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import Foundation

class UserSupervisor {
    static let shared = UserSupervisor()

    private(set) var email: String = ""
    private(set) var imageURLString: String = ""
    private(set) var score: Int = 0

    private init() {}

    var isLogined: Bool {
        return !self.email.isEmpty
    }

    func login(email: String, score: Int, imageURLString: String) {
        self.email = email
        self.imageURLString = imageURLString
        self.score = score
    }

    func add(score: Int) {
        self.score += score
    }

    func logout() {
        self.email = ""
        self.imageURLString = ""
    }
}
