//
//  SettingViewModel.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/26.
//

import Foundation

protocol SettingViewModelInterface {
    func addFeedback(content: String)
}

final class SettingViewModel: SettingViewModelInterface {
    private let usecase: FeedbackUseCaseInterface

    init(usecase: FeedbackUseCaseInterface) {
        self.usecase = usecase
    }

    func addFeedback(content: String) {
        self.usecase.addFeedback(content: content)
    }
}
