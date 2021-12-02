//
//  UserDTO.swift
//  Escaper
//
//  Created by 최완식 on 2021/12/02.
//

import Foundation

struct UserDTO: Decodable {
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

    func toDomain() -> User {
        return User(email: self.email,
                    name: self.name,
                    password: self.password,
                    imageURL: self.imageURL,
                    score: self.score)
    }
}
