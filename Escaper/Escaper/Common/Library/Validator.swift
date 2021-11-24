//
//  Validater.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/23.
//

import Foundation

enum Validator {
    enum State: String {
        case normal = ""
        case numberOfDigitsError = "8자리 이상 입력해주세요."
        case discordanceError = "비밀번호와 일치하지 않습니다."
        case alreadyExistError = "이미 등록된 이메일입니다."
        case notConfirmedError = "아이디와 비밀번호를 다시 확인해주세요."

        var value: String {
            return self.rawValue
        }
    }

    static var notConfirmedErrorString: String {
        return State.notConfirmedError.value
    }

    static var alreadyExistErrorString: String {
        return State.alreadyExistError.value
    }

    static func checkNumberOfDigits(text: String) -> String {
        if text.count < 8 {
            return State.numberOfDigitsError.value
        }
        return State.normal.value
    }

    static func checkDiscordance(text1: String, text2: String) -> String {
        if text1 != text2 {
            return State.discordanceError.value
        }
        return State.normal.value
    }
}
