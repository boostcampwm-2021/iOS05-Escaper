//
//  SortingOption.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

enum SortingOption: String {
    case satisfaction = "만족도순"
    case level = "난이도순"
    case distance = "거리순"

    var name: String {
        return self.rawValue
    }
}
