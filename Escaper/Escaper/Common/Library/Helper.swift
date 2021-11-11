//
//  Helper.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Foundation

enum Helper {
    static func parseUsername(email: String) -> String? {
        return email.components(separatedBy: "@").first 
    }
}
