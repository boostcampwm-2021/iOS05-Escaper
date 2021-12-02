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

    func add(feedback: Feedback) {
        self.service.add(feedbackDTO: feedback.toDTO())
    }
}
