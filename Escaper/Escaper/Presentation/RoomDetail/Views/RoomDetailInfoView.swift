//
//  RoomDetailInfoView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/09.
//

import UIKit

final class RoomDetailInfoView: UIView {
    private let leftInfoView = InfoDescriptionStackView()
    private let rightInfoView = InfoDescriptionStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(room: Room) {
        self.leftInfoView.inject(view: InfoDescriptionRatingStackView(title: "난이도", rating: Rating(rawValue: room.difficulty) ?? Rating.zero))
        self.leftInfoView.inject(view: InfoDescriptionDetailStackView(title: "장르", content: room.genre.name))
        self.leftInfoView.inject(view: InfoDescriptionDetailStackView(title: "활동성", content: room.activity))
        self.rightInfoView.inject(view: InfoDescriptionRatingStackView(title: "만족도", rating: Rating(rawValue: Int(room.averageSatisfaction)) ?? Rating.zero))
        self.rightInfoView.inject(view: InfoDescriptionDetailStackView(title: "제한 시간", content: "\(room.timeLimit)분"))
        self.rightInfoView.inject(view: InfoDescriptionDetailStackView(title: "최대 인원", content: "\(room.maxParty)인"))
    }
}

private extension RoomDetailInfoView {
    func configureLayout() {
        self.configureLeftInfoViewLayout()
        self.configureRightInfoViewLayout()
    }

    func configureLeftInfoViewLayout() {
        self.leftInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.leftInfoView)
        NSLayoutConstraint.activate([
            self.leftInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
    }

    func configureRightInfoViewLayout() {
        self.rightInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.rightInfoView)
        NSLayoutConstraint.activate([
            self.rightInfoView.leadingAnchor.constraint(equalTo: self.leftInfoView.trailingAnchor),
            self.rightInfoView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.rightInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
