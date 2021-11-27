//
//  Feedback.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/26.
//

import Foundation

struct Feedback {
    let content: String

    func toDTO() -> FeedbackDTO {
        return FeedbackDTO(content: self.content)
    }
}
