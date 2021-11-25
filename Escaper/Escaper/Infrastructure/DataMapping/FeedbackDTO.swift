//
//  FeedbackDTO.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/26.
//

import Foundation

struct FeedbackDTO: Decodable {
    let content: String

    func toDictionary() -> [String: Any] {
        let dictionary: [String: Any] = [
            "content": self.content
        ]
        return dictionary
    }
}
