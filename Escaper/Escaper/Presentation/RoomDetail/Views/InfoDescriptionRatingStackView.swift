//
//  InfoDescriptionRatingStackView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/25.
//

import UIKit

final class InfoDescriptionRatingStackView: UIStackView {
    private var titleLabel: UILabel = EDSLabel.b01B(color: .gloomyPink)
    private var ratingView: RatingView = {
        let rating = RatingView()
        rating.currentRating = 0
        return rating
    }()

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init(title: String, kind: RatingView.RatingImageKind, rating: Double) {
        self.init(frame: .zero)
        self.inject(title: title, rating: rating)
        self.ratingView.imageKind = kind
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.ratingView.starSize = (Int(self.ratingView.frame.width) - self.ratingView.starSpacing * 4) / 5 - 3
    }

    func inject(title: String, rating: Double) {
        self.titleLabel.text = title
        self.ratingView.currentRating = rating
    }
}

private extension InfoDescriptionRatingStackView {
    enum Constant {
        static let infoTitleWidth = CGFloat(70)
    }

    func configure() {
        self.configureStackView()
        self.configureTitleLabelLayout()
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.ratingView)
    }

    func configureStackView() {
        self.axis = .horizontal
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.widthAnchor.constraint(equalToConstant: Constant.infoTitleWidth).isActive = true
    }
}
