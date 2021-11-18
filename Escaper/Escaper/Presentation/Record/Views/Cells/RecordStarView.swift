//
//  RecordStarView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

final class RecordStarView: UIView {
    private let popularityLabel: UILabel = EDSLabel.b01B(text: "인기도", color: .gloomyPurple)
    private var popularityRatingView: RatingView = RatingView()
    private let difficultyLabel: UILabel = EDSLabel.b01B(text: "난이도", color: .gloomyPurple)
    private var difficultyRatingView: RatingView = RatingView()
    private let popularityHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let difficultyHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(satisfaction: Rating, difficulty: Rating) {
        self.popularityRatingView.fill(rating: satisfaction)
        self.difficultyRatingView.fill(rating: difficulty)
    }

    func prepareForReuse() {
        self.popularityRatingView = RatingView()
        self.difficultyRatingView = RatingView()
    }
}

private extension RecordStarView {
    enum Constant {
        static let defaultHeight = CGFloat(13)
        static let ratingViewWidth = CGFloat(65)
    }

    func configureLayout() {
        self.configurePopularityHorizontalStackView()
        self.configureDifficultyHorizontalStackView()
        self.configureVerticalStackView()
        self.configurePopularityLabelLayout()
        self.configureDifficultyLabelLayout()
        self.configurePopularityRatingViewLayout()
        self.configureDifficultyRatingViewLayout()
    }

    func configurePopularityHorizontalStackView() {
        self.popularityHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.popularityHorizontalStackView)
        self.popularityHorizontalStackView.addArrangedSubview(self.popularityLabel)
        self.popularityHorizontalStackView.addArrangedSubview(self.popularityRatingView)
    }

    func configureDifficultyHorizontalStackView() {
        self.difficultyHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.difficultyHorizontalStackView)
        self.difficultyHorizontalStackView.addArrangedSubview(self.difficultyLabel)
        self.difficultyHorizontalStackView.addArrangedSubview(self.difficultyRatingView)
    }

    func configureVerticalStackView() {
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.verticalStackView)
        self.verticalStackView.addArrangedSubview(self.popularityHorizontalStackView)
        self.verticalStackView.addArrangedSubview(self.difficultyHorizontalStackView)
        NSLayoutConstraint.activate([
            self.popularityHorizontalStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.difficultyHorizontalStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
        ])
    }

    func configurePopularityLabelLayout() {
        self.popularityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.popularityLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55)
        ])
    }

    func configureDifficultyLabelLayout() {
        self.difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.difficultyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.55)
        ])
    }

    func configurePopularityRatingViewLayout() {
        self.popularityRatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.popularityRatingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45)
        ])
    }

    func configureDifficultyRatingViewLayout() {
        self.difficultyRatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.difficultyRatingView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.45)
        ])
    }
}
