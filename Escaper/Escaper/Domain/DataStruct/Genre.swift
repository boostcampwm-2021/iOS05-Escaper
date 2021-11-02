//
//  Genre.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/02.
//

import Foundation

enum Genre: String {
    case all = "전체"
    case history = "역사"
    case fear = "공포"
    case action = "액션"
    case mystery = "미스터리"
    case thriller = "스릴러"
    case drama = "드라마"
    case crime = "범죄"
    case fantasy = "판타지"
    case sensitivity = "감성"
    case romance = "로맨스"
    case comedy = "코미디"
    case adventure = "모험"
    case outdoor = "야외"

    var previewImageAssetName: String {
        return String(describing: self) + "Preview"
    }

    var detailImageAssetName: String {
        return String(describing: self) + "Detail"
    }
}
