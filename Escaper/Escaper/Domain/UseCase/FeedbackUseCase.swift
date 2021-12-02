//
//  FeedbackUseCase.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/26.
//

import Foundation

protocol FeedbackUseCaseInterface {
    func addFeedback(content: String)
}

class FeedbackUsecase: FeedbackUseCaseInterface {
    private let repository: FeedbackRepositoryInterface

    init(repository: FeedbackRepositoryInterface) {
        self.repository = repository
    }

    func addFeedback(content: String) {
        self.repository.add(feedback: Feedback(content: content))
    }
}
