//
//  StoreRegion.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/18.
//

import Foundation

enum StoreRegion: String {
    case hongdae = "홍대"
    case gangnam = "강남"
    case gundae = "건대"
    case sinchon = "신천"
    case daehakro = "대학로"
    case gangbuk = "강북"
    case sinlim = "신림"
    case extra = "기타"

    var krName: String {
        return self.rawValue
    }
    var engName: String {
        return String(describing: self)
    }
    var code: Int {
        switch self {
        case .hongdae:
            return 1000
        case .gangnam:
            return 2000
        case .gundae:
            return 3000
        case .sinchon:
            return 4000
        case .daehakro:
            return 5000
        case .gangbuk:
            return 6000
        case .sinlim:
            return 7000
        case .extra:
            return 8000
        }
    }
}
