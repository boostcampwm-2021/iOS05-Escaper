//
//  AddRecordViewModel.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/11.
//

import Foundation

protocol AddRecordViewModelInterface {
    var room: Room? { get set }
    var satisfaction: Double { get set }
    var isSuccess: Bool { get set }
    var time: Int { get set }
    var records: [Record] { get set }
    var state: Observable<Bool> { get }

    func updateRoom(_ room: Room) -> Bool
    func changeSaveState()
    func post(email: String, imageURLString: String)
}

final class AddRecordViewModel: AddRecordViewModelInterface {
    private let recordUsecase: RecordUsecaseInterface
    private let userUsecase: UpdateUserUscCaseInterface
    var room: Room?
    var satisfaction: Double
    var isSuccess: Bool
    var time: Int
    var records: [Record]
    var state: Observable<Bool>

    init(recordUsecase: RecordUsecaseInterface, userUsecase: UpdateUserUscCaseInterface) {
        self.recordUsecase = recordUsecase
        self.userUsecase = userUsecase
        self.room = nil
        self.satisfaction = .zero
        self.isSuccess = false
        self.time = .zero
        self.records = []
        self.state = Observable(false)
    }

    func updateRoom(_ room: Room) -> Bool {
        let userEmail = UserSupervisor.shared.email
        let visited = room.records.contains { record in
            record.userEmail == userEmail
        }
        self.room = visited ? nil : room
        self.records = self.room?.records ?? []
        self.changeSaveState()
        return !visited
    }

    func changeSaveState() {
        if self.isSuccess {
            self.state.value = self.room != nil && self.time != 0
        } else {
            self.state.value = self.room != nil
        }
    }

    func calculateScore() -> Int? {
        guard let timeLimit = self.room?.timeLimit,
              let diffculty = self.room?.difficulty else { return nil }
        let score = Int((self.isSuccess ? 1 : 0) * (1 - Double(self.time)/Double(timeLimit*60)) * 100 * Double(diffculty) + 50.0)
        return score
    }

    func post(email: String, imageURLString: String) {
        guard let score = self.calculateScore(),
              let roomId = self.room?.roomId,
              let timeLimit = self.room?.timeLimit else { return }
        UserSupervisor.shared.add(score: score)
        self.userUsecase.updateScore(userEmail: email, score: UserSupervisor.shared.score)
        self.recordUsecase.addRecord(imageURLString: imageURLString,
                               userEmail: email,
                               roomId: roomId,
                               satisfaction: self.satisfaction,
                               isSuccess: self.isSuccess,
                               time: self.isSuccess ? self.time : timeLimit * 60,
                               records: self.records)
    }
}
