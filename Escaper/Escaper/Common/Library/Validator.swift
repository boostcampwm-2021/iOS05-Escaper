//
//  Validater.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

enum Validator {
    static func checkEmailFormat(text: String) -> Bool {
        return Validator.checkWithRegex(text: text, pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
    }

    static func checkUrlFormat(text: String) -> Bool {
        let regex = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        return Validator.checkWithRegex(text: text, pattern: regex)
    }

    static func checkTelephoneFormat(text: String) -> Bool {
        return Validator.checkWithRegex(text: text, pattern: "^\\d{2,3}-\\d{3,4}-\\d{4}$")
    }

    static func checkNumberOfDigits(text: String) -> Bool {
        return text.count >= 8
    }

    static func checkDiscordance(text1: String, text2: String) -> Bool {
        return text1 == text2
    }
}

private extension Validator {
    static func checkWithRegex(text: String, pattern: String) -> Bool {
        let range = NSRange(location: 0, length: text.count)
        if let idRegex = try? NSRegularExpression(pattern: pattern) {
            return idRegex.matches(in: text, options: [], range: range).isNotEmpty
        }
        return true
    }
}
