//
//  RoomOverviewCollectionViewCell.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

final class RoomOverviewTableViewCell: UITableViewCell {
    static let identifier = String(describing: RoomOverviewTableViewCell.self)

    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = EDSLabel.b02B(color: .skullLightWhite)
        label.lineBreakMode = .byWordWrapping
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let distanceLabel = EDSLabel.b03R(color: .skullWhite)
    private let ratingContainerView = RatingContainerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func update(_ room: Room) {
        self.genreImageView.image = UIImage(named: room.genre.previewImageAssetName)
        self.titleLabel.text = room.title
        self.ratingContainerView.update(difficulty: room.difficulty, satisfaction: room.averageSatisfaction)
        self.distanceLabel.text = Helper.measureDistance(room.distance)
        self.accessibilityLabel = "테마 이름 \(room.title), 테마 종류 \(room.genre.name), 난이도 \(room.difficulty)점, 만족도 \(room.averageSatisfaction)점, 거리 " + Helper.measureDistance(room.distance)
        self.accessibilityTraits = .button
        self.accessibilityHint = "위 아래로 스와이프해서 다양한 방탈출 정보를 확인 할 수 있고 더블 탭을 하면 방 세부 정보를 확인 할 수 있어요"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.genreImageView.image = nil
        self.titleLabel.text = ""
        self.ratingContainerView.prepareForReuse()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.genreImageView.layer.cornerRadius = self.genreImageView.bounds.width/2
        self.contentView.layer.cornerRadius = Constant.cornerRadius
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: Constant.verticalSpace, left: Constant.horizontalSpace, bottom: Constant.verticalSpace, right: Constant.horizontalSpace))
    }
}

private extension RoomOverviewTableViewCell {
    enum Constant {
        static let cornerRadius = CGFloat(15)
        static let imageLength = CGFloat(50)
        static let verticalSpace = CGFloat(5)
        static let horizontalSpace = CGFloat(20)
        static let contentSideSpace = CGFloat(24)
        static let ratingContainerWidth = CGFloat(100)
        static let ratingContainerHeight = CGFloat(30)
        static let ratingVerticalSpace = CGFloat(8)
        static let imageYAnchorSpace = CGFloat(8)
        static let titleYAnchorSpace = CGFloat(20)
        static let titleSpace = CGFloat(20)
        static let distanceSpace = CGFloat(4)
    }

    func configure() {
        self.configureCell()
        self.configureGenreImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureRatingContainerViewLayout()
        self.configureDistanceLabelLayout()
    }

    func configureCell() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
        self.backgroundColor = .clear
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = EDSColor.gloomyBrown.value
    }

    func configureGenreImageViewLayout() {
        self.genreImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.genreImageView)
        NSLayoutConstraint.activate([
            self.genreImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -Constant.imageYAnchorSpace),
            self.genreImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Constant.contentSideSpace),
            self.genreImageView.heightAnchor.constraint(equalToConstant: Constant.imageLength),
            self.genreImageView.widthAnchor.constraint(equalToConstant: Constant.imageLength)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constant.contentSideSpace),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -Constant.titleYAnchorSpace),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.genreImageView.leadingAnchor, constant: -Constant.titleSpace)
        ])
    }

    func configureRatingContainerViewLayout() {
        self.ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.ratingContainerView)
        NSLayoutConstraint.activate([
            self.ratingContainerView.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.ratingContainerView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.ratingVerticalSpace),
            self.ratingContainerView.heightAnchor.constraint(equalToConstant: Constant.ratingContainerHeight),
            self.ratingContainerView.widthAnchor.constraint(equalToConstant: Constant.ratingContainerWidth)
        ])
    }

    func configureDistanceLabelLayout() {
        self.distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.distanceLabel)
        NSLayoutConstraint.activate([
            self.distanceLabel.centerXAnchor.constraint(equalTo: self.genreImageView.centerXAnchor),
            self.distanceLabel.topAnchor.constraint(equalTo: self.genreImageView.bottomAnchor, constant: Constant.distanceSpace)
        ])
    }
}
