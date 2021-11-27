//
//  InfoDescriptionRatingStackView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/25.
//

import UIKit

final class InfoDescriptionRatingStackView: UIStackView {
    private var titleLabel: UILabel = EDSLabel.b01B(color: .gloomyPink)
    private var ratingLabel = RatingView()

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init(title: String, rating: Rating) {
        self.init(frame: .zero)
        self.inject(title: title, rating: rating)
    }

    func inject(title: String, rating: Rating) {
        self.titleLabel.text = title
        self.ratingLabel.fill(rating: rating)
    }
}

private extension InfoDescriptionRatingStackView {
    enum Constant {
        static let infoTitleWidth = CGFloat(70)
    }

    func configure() {
        self.configureStackView()
        self.configureTitleLabelLayout()
        self.configureRatingView()
        self.addArrangedSubview(self.titleLabel)
        self.addArrangedSubview(self.ratingLabel)
    }

    func configureStackView() {
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins.right = 20
        self.axis = .horizontal
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.widthAnchor.constraint(equalToConstant: Constant.infoTitleWidth).isActive = true
    }

    func configureRatingView() {
        self.ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.ratingLabel.heightAnchor.constraint(equalTo: self.ratingLabel.widthAnchor, multiplier: 1/6)
        ])
    }
}
