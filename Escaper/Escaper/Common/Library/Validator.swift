//
//  Validater.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

enum Validator {
    static func checkEmailFormat(text: String) -> Bool {
        let range = NSRange(location: 0, length: text.count)
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        if let idRegex = try? NSRegularExpression(pattern: pattern) {
            let isMatched = idRegex.matches(in: text, options: [], range: range)
            if isMatched == [] {
                return false
            } else {
                return true
            }
        }
        return true
    }

    static func checkNumberOfDigits(text: String) -> Bool {
        if text.count < 8 {
            return false
        }
        return true
    }

    static func checkDiscordance(text1: String, text2: String) -> Bool {
        if text1 != text2 {
            return false
        }
        return true
    }
}
