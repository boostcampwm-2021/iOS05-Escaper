//
//  ColorPalette.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/03.
//

import Foundation

enum ColorPalette {
    case bloodyBlack
    case bloodyBurgundy
    case bloodyRed
    case charcoal
    case gloomyPink
    case gloomyPurple
    case gloomyRed
    case pumpkin
    case skullLightWhite
    case skullWhite

    var code: String {
        return String(describing: self)
    }
}
