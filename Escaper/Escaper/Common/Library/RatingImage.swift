//
//  RatingImage.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import Foundation

enum RatingImage: String {
    var name: String {
        return self.rawValue
    }

    case starFilled = "star.filled"
    case starUnfilled = "star.unfilled"
}
