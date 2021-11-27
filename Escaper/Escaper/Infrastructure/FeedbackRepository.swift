//
//  FeedbackRepository.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/26.
//

import Foundation

final class FeedbackRepository: FeedbackRepositoryInterface {
    private let service: FeedbackNetwork

    init(service: FeedbackNetwork) {
        self.service = service
    }

    func addFeedback(feedback: Feedback) {
        self.service.addFeedback(feedbackDTO: feedback.toDTO())
    }
}
