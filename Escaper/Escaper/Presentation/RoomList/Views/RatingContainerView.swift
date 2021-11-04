//
//  RatingContainerView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

class RatingContainerView: UIView {
    enum Constant {
        static let labelWidth = CGFloat(30)
        static let ratingViewHeight = CGFloat(10)
        static let ratingViewWidth = Constant.ratingViewHeight * CGFloat(Rating.maxRating) + RatingView.Constant.summationOfElementSpacing
    }

    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "난이도"
        label.textColor = UIColor(named: ColorPalette.skullWhite.name)
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    private let satisfactionLabel: UILabel = {
        let label = UILabel()
        label.text = "만족도"
        label.textColor = UIColor(named: ColorPalette.skullWhite.name)
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    private let levelRatingView = RatingView()
    private let satisfactionRatingView = RatingView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func update() {
        self.levelRatingView.fill(rating: .five)
        self.satisfactionRatingView.fill(rating: .two)
    }

    func prepareForReuse() {
        self.levelLabel.text = ""
        self.levelRatingView.fill(rating: .zero)
        self.satisfactionLabel.text = ""
        self.satisfactionRatingView.fill(rating: .zero)
    }
}

private extension RatingContainerView {
    func configure() {
        self.configureLevelLabelLayout()
        self.configureSatisfactionLabelLayout()
        self.configureLevelRatingViewLayout()
        self.configureSatisfactionRatingViewLayout()
    }

    func configureLevelLabelLayout() {
        self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.levelLabel)
        NSLayoutConstraint.activate([
            self.levelLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.levelLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.levelLabel.widthAnchor.constraint(equalToConstant: Constant.labelWidth)
        ])
    }

    func configureSatisfactionLabelLayout() {
        self.satisfactionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.satisfactionLabel)
        NSLayoutConstraint.activate([
            self.satisfactionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.satisfactionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.satisfactionLabel.widthAnchor.constraint(equalToConstant: Constant.labelWidth)
        ])
    }

    func configureLevelRatingViewLayout() {
        self.levelRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.levelRatingView)
        NSLayoutConstraint.activate([
            self.levelRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.levelRatingView.centerYAnchor.constraint(equalTo: self.levelLabel.centerYAnchor, constant: -0.5),
            self.levelRatingView.widthAnchor.constraint(equalToConstant: Constant.ratingViewWidth),
            self.levelRatingView.heightAnchor.constraint(equalToConstant: Constant.ratingViewHeight)
        ])
    }

    func configureSatisfactionRatingViewLayout() {
        self.satisfactionRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.satisfactionRatingView)
        NSLayoutConstraint.activate([
            self.satisfactionRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.satisfactionRatingView.centerYAnchor.constraint(equalTo: self.satisfactionLabel.centerYAnchor, constant: -0.7),
            self.satisfactionRatingView.widthAnchor.constraint(equalToConstant: Constant.ratingViewWidth),
            self.satisfactionRatingView.heightAnchor.constraint(equalToConstant: Constant.ratingViewHeight)
        ])
    }
}
