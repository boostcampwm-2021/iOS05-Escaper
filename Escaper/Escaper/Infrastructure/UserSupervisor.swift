//
//  UserSupervisor.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import Foundation

class UserSupervisor {
    static let shared = UserSupervisor()

    private var email: String = ""

    private init() {}

    var isLogined: Bool {
        return self.email.isEmpty
    }

    func login(email: String) {
        self.email = email
    }

    func logout() {
        self.email = ""
    }
}
