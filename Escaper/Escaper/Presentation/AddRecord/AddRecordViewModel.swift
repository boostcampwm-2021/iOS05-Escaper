//
//  AddRecordViewModel.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/11.
//

import Foundation

protocol AddRecordViewModelInput {
    func post(email: String, imageUrlString: String)
}

protocol AddRecordViewModelOutput {
    var roomId: String { get set }
    var satisfaction: Rating { get set }
    var isSuccess: Bool { get set }
    var time: Int { get set }
    var state: Observable<Bool> { get }

    func changeSaveState()
}

class AddRecordViewModel: AddRecordViewModelInput, AddRecordViewModelOutput {
    private let usecase: RecordUsecaseInterface
    var roomId: String
    var satisfaction: Rating
    var isSuccess: Bool
    var time: Int
    var state: Observable<Bool>

    init(usecase: RecordUsecaseInterface) {
        self.usecase = usecase
        self.roomId = ""
        self.satisfaction = .four
        self.isSuccess = true
        self.time = 0
        self.state = Observable(false)
    }

    func changeSaveState() {
        self.state.value = !self.roomId.isEmpty && self.time != 0
    }

    func post(email: String, imageUrlString: String) {
        self.usecase.addRecord(imageUrlString: imageUrlString,
                               userEmail: email,
                               roomId: self.roomId,
                               satisfaction: self.satisfaction,
                               isSuccess: self.isSuccess,
                               time: self.time)
    }
}
