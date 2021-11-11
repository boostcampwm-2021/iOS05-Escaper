//
//  RecordStarView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

class RecordStarView: UIView {
    enum Constant {
        static let defaultHeight = CGFloat(13)
        static let ratingViewWidth = CGFloat(65)
    }

    private let popularityLabel: UILabel = {
        let label = EDSLabel.b01B(text: "인기도", color: .gloomyPurple)
        return label
    }()
    private let popularityRatingView: RatingView = {
        let view = RatingView()
        return view
    }()
    private let difficultyLabel: UILabel = {
        let label = EDSLabel.b01B(text: "난이도", color: .gloomyPurple)
        return label
    }()
    private let difficultyRatingView: RatingView = {
        let view = RatingView()
        return view
    }()
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
}

extension RecordStarView {
    func configureLayout() {
        configurePopularityHorizontalStackView()
        configureDifficultyHorizontalStackView()
        configureVerticalStackView()
        configurePopularityLabelLayout()
        configureDifficultyLabelLayout()
        configurePopularityRatingViewLayout()
        configureDifficultyRatingViewLayout()
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
