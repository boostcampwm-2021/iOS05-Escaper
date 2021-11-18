//
//  SortingOption.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

enum SortingOption: String, Tagable, CaseIterable {
    case satisfaction = "만족도"
    case difficulty = "난이도"
    case distance = "거리"

    var name: String {
        return self.rawValue
    }
}
