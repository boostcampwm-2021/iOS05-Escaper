//
//  RatingContainerView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

final class RatingContainerView: UIView {
    private let levelLabel = EDSLabel.b03R(text: "난이도", color: .skullWhite)
    private let satisfactionLabel = EDSLabel.b03R(text: "만족도", color: .skullWhite)
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

    func update(difficulty: Int, satisfaction: Double) {
        self.levelRatingView.fill(rating: Rating(rawValue: difficulty)!)
        self.satisfactionRatingView.fill(rating: Rating(rawValue: Int(satisfaction))!)
    }

    func prepareForReuse() {
        self.levelRatingView.fill(rating: .zero)
        self.satisfactionRatingView.fill(rating: .zero)
    }
}

private extension RatingContainerView {
    enum Constant {
        static let labelWidth = CGFloat(30)
        static let ratingViewHeight = CGFloat(10)
        static let ratingViewWidth = Constant.ratingViewHeight * CGFloat(Rating.maxRating) + RatingView.Constant.summationOfElementSpacing
    }
    
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
