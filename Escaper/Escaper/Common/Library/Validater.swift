//
//  Validater.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

enum Validater {
    static func checkNumberOfDigits(text: String) -> String {
        if text.count < 8 {
            return MessageType.numberOfDigitsError.value
        }
        return MessageType.normal.value
    }

    static func checkDiscordance(text1: String, text2: String) -> String {
        if text1 != text2 {
            return MessageType.discordanceError.value
        }
        return MessageType.normal.value
    }
}
