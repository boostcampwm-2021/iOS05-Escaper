//
//  TextFieldState.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/27.
//

import Foundation

enum TextFieldState: String {
    case normal = ""
    case emailFormatError = "이메일 형식이 올바르지 않습니다."
    case numberOfDigitsError = "8자리 이상 입력해주세요."
    case discordanceError = "비밀번호와 일치하지 않습니다."
    case alreadyExistError = "이미 등록된 이메일입니다."
    case notConfirmedError = "아이디와 비밀번호를 다시 확인해주세요."

    var value: String {
        return self.rawValue
    }
}
