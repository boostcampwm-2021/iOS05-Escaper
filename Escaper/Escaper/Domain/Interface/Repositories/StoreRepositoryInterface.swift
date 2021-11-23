//
//  StoreRepositoryInterface.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/23.
//

import Foundation

protocol StoreRepositoryInterface {
    func query(name: String, completion: @escaping (Result<[Store], Error>) -> Void)
}
