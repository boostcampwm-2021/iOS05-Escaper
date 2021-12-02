//
//  RecordViewModel.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/11.
//

import Foundation

protocol RecordViewModelInput {
    func fetch(userEmail: String)
}

protocol RecordViewModelOutput {
    var records: Observable<[RecordCard]> { get }
}

protocol RecordViewModel: RecordViewModelInput, RecordViewModelOutput { }

final class DefaultRecordViewModel: RecordViewModel {
    internal var records: Observable<[RecordCard]>
    private let useCase: RecordUsecase?

    init(useCase: RecordUsecase) {
        self.useCase = useCase
        self.records = Observable([])
    }

    func fetch(userEmail: String) {
        self.useCase?.fetchAllRecords(userEmail: userEmail) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let record):
                guard !self.records.value.contains(record) else { return }
                let records = self.records.value + [record]
                self.records.value = records.sorted(by: { $0.createdTime > $1.createdTime })
            case .failure:
                self.records.value = []
            }
        }
    }
}
