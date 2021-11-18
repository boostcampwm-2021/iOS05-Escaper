//
//  RoomDetailInfoView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/09.
//

import UIKit

final class RoomDetailInfoView: UIView {
    private let levelLabel = EDSLabel.b01B(text: "난이도", color: .skullWhite)
    private let levelRatingView = RatingView()
    private let satisfactionLabel = EDSLabel.b01B(text: "만족도", color: .skullLightWhite)
    private let satisfactionRatingView = RatingView()
    private let homepageTitleLabel = EDSLabel.b01B(text: "홈페이지", color: .skullLightWhite)
    private let homepageLabel: UILabel = {
        let label = EDSLabel.b02R(text: "홈페이지가 없습니다.", color: .skullLightWhite)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let phoneNumberTitleLabel = EDSLabel.b01B(text: "전화번호", color: .skullLightWhite)
    private let phoneNumberLabel = EDSLabel.b02R(text: "전화번호가 없습니다.", color: .skullLightWhite)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(room: Room) {
        self.levelRatingView.fill(rating: Rating(rawValue: room.difficulty)!)
        self.satisfactionRatingView.fill(rating: Rating(rawValue: Int(room.averageSatisfaction))!)
        // TODO: - StoreUsecase 추가하여 Store 정보를 가져와서 반영해야 함
//        self.homepageLabel.text = room.homepage
//        self.phoneNumberLabel.text = room.telephone
    }
}

private extension RoomDetailInfoView {
    enum Constant {
        static let titleLabelSize: CGFloat = 150
        static let ratingViewHeight: CGFloat = 12
        static let ratingViewWidth: CGFloat = 72
        static let ratingViewAnchorY: CGFloat = 1
        static let sideSpace: CGFloat = 16
        static let gapSapce: CGFloat = 48
    }

    func configureLayout() {
        self.configureLevelLabelLayout()
        self.configureSatisfactionLabelLayout()
        self.configureHomepageTitleLabelLayout()
        self.configurePhoneNumberTitleLabelLayout()
        self.configureLevelRatingViewLayout()
        self.configureSatisfactionRatingViewLayout()
        self.configureHomepageLabelLayout()
        self.configurePhoneNumberLabelLayout()
    }

    func configureLevelLabelLayout() {
        self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.levelLabel)
        NSLayoutConstraint.activate([
            self.levelLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.sideSpace),
            self.levelLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace)
        ])
    }

    func configureSatisfactionLabelLayout() {
        self.satisfactionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.satisfactionLabel)
        NSLayoutConstraint.activate([
            self.satisfactionLabel.leadingAnchor.constraint(equalTo: self.levelLabel.leadingAnchor),
            self.satisfactionLabel.topAnchor.constraint(equalTo: self.levelLabel.bottomAnchor, constant: Constant.sideSpace)
        ])
    }

    func configureHomepageTitleLabelLayout() {
        self.homepageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.homepageTitleLabel)
        NSLayoutConstraint.activate([
            self.homepageTitleLabel.leadingAnchor.constraint(equalTo: self.satisfactionLabel.leadingAnchor),
            self.homepageTitleLabel.topAnchor.constraint(equalTo: self.satisfactionLabel.bottomAnchor, constant: Constant.sideSpace)
        ])
    }

    func configurePhoneNumberTitleLabelLayout() {
        self.phoneNumberTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.phoneNumberTitleLabel)
        NSLayoutConstraint.activate([
            self.phoneNumberTitleLabel.leadingAnchor.constraint(equalTo: self.homepageTitleLabel.leadingAnchor),
            self.phoneNumberTitleLabel.topAnchor.constraint(equalTo: self.homepageTitleLabel.bottomAnchor, constant: Constant.sideSpace)
        ])
    }

    func configureLevelRatingViewLayout() {
        self.levelRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.levelRatingView)
        NSLayoutConstraint.activate([
            self.levelRatingView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor, constant: -Constant.ratingViewAnchorY),
            self.levelRatingView.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: Constant.gapSapce),
            self.levelRatingView.widthAnchor.constraint(equalToConstant: Constant.ratingViewWidth),
            self.levelRatingView.heightAnchor.constraint(equalToConstant: Constant.ratingViewHeight)
        ])
    }

    func configureSatisfactionRatingViewLayout() {
        self.satisfactionRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.satisfactionRatingView)
        NSLayoutConstraint.activate([
            self.satisfactionRatingView.centerYAnchor.constraint(equalTo: self.satisfactionLabel.centerYAnchor, constant: Constant.ratingViewAnchorY),
            self.satisfactionRatingView.leadingAnchor.constraint(equalTo: self.levelRatingView.leadingAnchor),
            self.satisfactionRatingView.widthAnchor.constraint(equalToConstant: Constant.ratingViewWidth),
            self.satisfactionRatingView.heightAnchor.constraint(equalToConstant: Constant.ratingViewHeight)
        ])
    }

    func configureHomepageLabelLayout() {
        self.homepageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.homepageLabel)
        NSLayoutConstraint.activate([
            self.homepageLabel.centerYAnchor.constraint(equalTo: self.homepageTitleLabel.centerYAnchor),
            self.homepageLabel.leadingAnchor.constraint(equalTo: self.satisfactionRatingView.leadingAnchor),
            self.homepageLabel.widthAnchor.constraint(equalToConstant: Constant.titleLabelSize)
        ])
    }

    func configurePhoneNumberLabelLayout() {
        self.phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.phoneNumberLabel)
        NSLayoutConstraint.activate([
            self.phoneNumberLabel.centerYAnchor.constraint(equalTo: self.phoneNumberTitleLabel.centerYAnchor),
            self.phoneNumberLabel.leadingAnchor.constraint(equalTo: self.homepageLabel.leadingAnchor),
            self.phoneNumberLabel.widthAnchor.constraint(equalToConstant: Constant.titleLabelSize)
        ])
    }
}
