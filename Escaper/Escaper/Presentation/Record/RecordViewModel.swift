//
//  RecordViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/11.
//

import Foundation

protocol RecordViewModelInput {
    func fetch()
}

protocol RecordViewModelOutput {
    var records: Observable<[Record]> { get }
}

protocol RecordViewModel: RecordViewModelInput, RecordViewModelOutput { }

final class DefaultRecordViewModel: RecordViewModel {
    private(set) var records: Observable<[Record]>?
    private let useCase: RecordUseCase = RecordUseCase()

    init(useCase: RecordInterface) {
        self.useCase = useCase
        self.records = Observable([])
    }

    func fetch() {
        self.useCase.fetch() { [weak self] records in
            self?.records = records
        }
    }
}
