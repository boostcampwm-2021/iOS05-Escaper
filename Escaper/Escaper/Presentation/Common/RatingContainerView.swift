//
//  RatingContainerView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

final class RatingContainerView: UIView {
    private let difficultyLabel = EDSLabel.b03R(text: "난이도", color: .skullWhite)
    private let satisfactionLabel = EDSLabel.b03R(text: "만족도", color: .skullWhite)
    private let difficultyRatingView: RatingView = {
        let rating = RatingView()
        rating.currentRating = 0
        rating.starSpacing = 2
        rating.imageKind = .lock
        return rating
    }()
    private let satisfactionRatingView: RatingView = {
        let rating = RatingView()
        rating.currentRating = 0
        rating.starSpacing = 2
        rating.imageKind = .star
        return rating
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.difficultyRatingView.starSize = (Int(self.difficultyRatingView.frame.width) - (self.difficultyRatingView.starSpacing * 4) ) / 5
        self.satisfactionRatingView.starSize = (Int(self.satisfactionRatingView.frame.width) - (self.satisfactionRatingView.starSpacing * 4) ) / 5
    }

    func update(difficulty: Int, satisfaction: Double) {
        self.difficultyRatingView.currentRating = Double(difficulty)
        self.satisfactionRatingView.currentRating = satisfaction
    }

    func prepareForReuse() {
        self.difficultyRatingView.currentRating = 0
        self.satisfactionRatingView.currentRating = 0
    }
}

private extension RatingContainerView {
    enum Constant {
        static let labelWidth = CGFloat(30)
    }

    func configure() {
        self.configureDifficultyLabelLayout()
        self.configureSatisfactionLabelLayout()
        self.configureLevelRatingViewLayout()
        self.configureSatisfactionRatingViewLayout()
    }

    func configureDifficultyLabelLayout() {
        self.difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.difficultyLabel)
        NSLayoutConstraint.activate([
            self.difficultyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.difficultyLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.difficultyLabel.widthAnchor.constraint(equalToConstant: Constant.labelWidth)
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
        self.difficultyRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.difficultyRatingView)
        NSLayoutConstraint.activate([
            self.difficultyRatingView.leadingAnchor.constraint(equalTo: self.difficultyLabel.trailingAnchor, constant: 5),
            self.difficultyRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.difficultyRatingView.centerYAnchor.constraint(equalTo: self.difficultyLabel.centerYAnchor),
            self.difficultyRatingView.heightAnchor.constraint(equalTo: self.difficultyLabel.heightAnchor)
        ])
    }

    func configureSatisfactionRatingViewLayout() {
        self.satisfactionRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.satisfactionRatingView)
        NSLayoutConstraint.activate([
            self.satisfactionRatingView.leadingAnchor.constraint(equalTo: self.satisfactionLabel.trailingAnchor, constant: 5),
            self.satisfactionRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.satisfactionRatingView.centerYAnchor.constraint(equalTo: self.satisfactionLabel.centerYAnchor),
            self.satisfactionRatingView.heightAnchor.constraint(equalTo: self.satisfactionLabel.heightAnchor)
        ])
    }
}
