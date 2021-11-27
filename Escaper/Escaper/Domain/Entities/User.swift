//
//  User.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/17.
//

import Foundation

struct User: Decodable {
    let email: String
    let name: String
    let password: String
    let imageURL: String
    let score: Int

    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "email": self.email,
            "name": self.name,
            "password": self.password,
            "imageURL": self.imageURL,
            "score": self.score
        ]
        return dictionary
    }
}
