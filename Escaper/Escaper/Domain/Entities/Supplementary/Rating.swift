//
//  Rating.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import Foundation

enum Rating: Int {
    static let maxRating: Int = 5
    
    case zero = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5

    var value: Int {
        return self.rawValue
    }
}
