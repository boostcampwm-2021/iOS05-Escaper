//
//  RecordRepositoryInterface.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/10.
//

import Foundation

protocol RecordRepositoryInterface {
    func query(userEmail: String, completion: @escaping (Result<[Record], Error>) -> Void)
    func addRecord(_ record: Record)
}
