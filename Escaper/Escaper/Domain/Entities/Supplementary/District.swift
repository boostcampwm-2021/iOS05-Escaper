//
//  District.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/04.
//

import Foundation

enum District: String, CaseIterable, Codable {
    case all = "서울 전체"
    case gangnamgu = "강남구"
    case gangdonggu = "강동구"
    case gangbukgu = "강북구"
    case gangseogu = "강서구"
    case gwanakgu = "관악구"
    case gwangjingu = "광진구"
    case gurogu = "구로구"
    case geumcheongu = "금천구"
    case nowongu = "노원구"
    case dobonggu = "도봉구"
    case dongdaemungu = "동대문구"
    case dongjakgu = "동작구"
    case mapogu = "마포구"
    case seodaemungu = "서대문구"
    case seochogu = "서초구"
    case seongdonggu = "성동구"
    case seongbukgu = "성북구"
    case songpagu = "송파구"
    case yangcheongu = "양천구"
    case yeongdeungpogu = "영등포구"
    case yongsangu = "용산구"
    case eunpyeonggu = "은평구"
    case jongnogu = "종로구"
    case junggu = "중구"
    case jungnanggu = "중랑구"
    case none = "없음"

    var name: String {
        return self.rawValue
    }
}
