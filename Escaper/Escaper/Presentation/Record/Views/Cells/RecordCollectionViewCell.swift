//
//  RecordCollectionViewCell.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/09.
//

import UIKit

final class RecordCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: RecordCollectionViewCell.self)

    enum Constant {
        static var defaultHorizontalSpace = CGFloat(50)
        static var longHorizontalSpace = CGFloat(180)
        static var middleHorizontalSpace = CGFloat(120)
        static var shortHorizontalSpace = CGFloat(50)
        static let longVerticalSpace = CGFloat(30)
        static let middleVerticalSpace = CGFloat(15)
        static let shortVerticalSpace = CGFloat(10)
    }

    private let backgroundImageView: UIImageView = UIImageView(image: EDSImage.recordCard.value)
    private let recordHeadView: RecordHeadView = RecordHeadView()
    private let recordUserView: RecordUserView = RecordUserView()
    private let recordStarView: RecordStarView = RecordStarView()
    private let recordResultView: RecordResultView = RecordResultView()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(EDSColor.skullWhite.value, for: .normal)
        button.backgroundColor = EDSColor.gloomyPurple.value
        button.layer.cornerRadius = 10
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(record: Record) {
        self.recordHeadView.update(imageURLString: record.imageUrlString, title: record.roomName, place: record.storeName)
        self.recordUserView.update(nickname: record.username, result: record.isSuccess)
        self.recordStarView.update(satisfaction: record.satisfaction, difficulty: record.difficulty)
        self.recordResultView.update(playerRank: record.rank, numberOfPlayers: record.numberOfTotalPlayers, time: record.time)
    }

    override func prepareForReuse() {
        self.recordHeadView.prepareForReuse()
        self.recordUserView.prepareForReuse()
        self.recordStarView.prepareForReuse()
        self.recordResultView.prepareForReuse()
    }
}

extension RecordCollectionViewCell {
    func configureLayout() {
        self.configureViewLayout()
        self.configureBackgroundImageViewLayout()
        self.configureRecordHeadViewLayout()
        self.configureRecordUserViewLayout()
        self.configureRecordStarViewLayout()
        self.configureRecordResultViewLayout()
        self.configureShareButtonLayout()
    }

    func configureViewLayout() {
        self.backgroundColor = EDSColor.bloodyBlack.value
    }

    func configureBackgroundImageViewLayout() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backgroundImageView)
        NSLayoutConstraint.activate([
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureRecordHeadViewLayout() {
        self.recordHeadView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordHeadView)
        NSLayoutConstraint.activate([
            self.recordHeadView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.middleVerticalSpace),
            self.recordHeadView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.recordHeadView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func configureRecordUserViewLayout() {
        self.recordUserView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordUserView)
        NSLayoutConstraint.activate([
            self.recordUserView.topAnchor.constraint(equalTo: self.recordHeadView.bottomAnchor, constant: Constant.longVerticalSpace),
            self.recordUserView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35),
            self.recordUserView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -35),
            self.recordUserView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.14)
        ])
    }

    func configureRecordStarViewLayout() {
        self.recordStarView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordStarView)
        NSLayoutConstraint.activate([
            self.recordStarView.topAnchor.constraint(equalTo: self.recordUserView.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.recordStarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.defaultHorizontalSpace),
            self.recordStarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.defaultHorizontalSpace),
            self.recordStarView.heightAnchor.constraint(equalToConstant: CGFloat(40))
        ])
    }

    func configureRecordResultViewLayout() {
        self.recordResultView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordResultView)
        NSLayoutConstraint.activate([
            self.recordResultView.topAnchor.constraint(equalTo: self.recordStarView.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.recordResultView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.defaultHorizontalSpace),
            self.recordResultView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.defaultHorizontalSpace),
            self.recordResultView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.18)
        ])
    }

    func configureShareButtonLayout() {
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.shareButton)
        NSLayoutConstraint.activate([
            self.shareButton.topAnchor.constraint(equalTo: self.recordResultView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.shareButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.defaultHorizontalSpace),
            self.shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.defaultHorizontalSpace),
            self.shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.11)
        ])
    }
}
