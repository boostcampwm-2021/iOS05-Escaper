//
//  RecordEmptyGuideView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

final class RecordEmptyGuideView: RecordGuideView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
}

private extension RecordEmptyGuideView {
    enum Content {
        static let title = "자, 이제 시작해보아요."
        static let description = """
        마치 탐정이 된 것 같은 추리 테마,
        금방이라도 유령이 나올 것 같은 공포 테마,
        그리고 가슴이 먹먹해지는 감성 테마까지.

        당신이 느꼈던 모든 감정들.
        이제 그 경험을 남겨보세요.
        """
    }

    func configure() {
        super.inject(mainImage: EDSImage.recordCandle.value, title: Content.title, description: Content.description)
    }
}
