//
//  AddRecordViewModel.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/11.
//

import Foundation

protocol AddRecordViewModelInput {
    func post(email: String, imageURLString: String)
}

protocol AddRecordViewModelOutput {
    var roomId: String { get set }
    var satisfaction: Double { get set }
    var isSuccess: Bool { get set }
    var time: Int { get set }
    var records: [Record] { get set }
    var state: Observable<Bool> { get }

    func changeSaveState()
}

final class AddRecordViewModel: AddRecordViewModelInput, AddRecordViewModelOutput {
    private let usecase: RecordUsecaseInterface
    var roomId: String
    var satisfaction: Double
    var isSuccess: Bool
    var time: Int
    var records: [Record]
    var state: Observable<Bool>

    init(usecase: RecordUsecaseInterface) {
        self.usecase = usecase
        self.roomId = ""
        self.satisfaction = .zero
        self.isSuccess = true
        self.time = .zero
        self.records = []
        self.state = Observable(false)
    }

    func changeSaveState() {
        self.state.value = !self.roomId.isEmpty && self.time != 0
    }

    func post(email: String, imageURLString: String) {
        self.usecase.addRecord(imageURLString: imageURLString,
                               userEmail: email,
                               roomId: self.roomId,
                               satisfaction: self.satisfaction,
                               isSuccess: self.isSuccess,
                               time: self.time,
                               records: self.records)
    }
}
