//
//  RecordStarView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

final class RecordStarView: UIView {
    private let satisfactionLabel: UILabel = {
        let label = EDSLabel.b01B(text: "만족도", color: .gloomyPurple)
        label.textAlignment = .center
        return label
    }()
    private let satisfactionRatingView: RatingView = {
        let ratingView = RatingView()
        ratingView.imageKind = .star
        return ratingView
    }()
    private let difficultyLabel: UILabel = {
        let label = EDSLabel.b01B(text: "난이도", color: .gloomyPurple)
        label.textAlignment = .center
        return label
    }()
    private let difficultyRatingView: RatingView = {
        let ratingView = RatingView()
        ratingView.imageKind = .lock
        return ratingView
    }()
    private let satisfactionVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    private let difficultyVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.satisfactionRatingView.starSize = (Int(satisfactionVerticalStackView.frame.width) - (satisfactionRatingView.starSpacing * 4) ) / 5 - 5
        self.difficultyRatingView.starSize = (Int(difficultyVerticalStackView.frame.width) - (difficultyRatingView.starSpacing * 4) ) / 5 - 5
    }

    func update(satisfaction: Double, difficulty: Double) {
        self.satisfactionRatingView.currentRating = satisfaction
        self.difficultyRatingView.currentRating = difficulty
    }

    func prepareForReuse() {
        self.satisfactionRatingView.currentRating = 3
        self.difficultyRatingView.currentRating = 3
    }
}

private extension RecordStarView {
    func configureLayout() {
        self.configureArrangedSubviews()
        self.configureHorizontalStackViewLayout()
    }

    func configureArrangedSubviews() {
        self.satisfactionVerticalStackView.addArrangedSubview(self.satisfactionLabel)
        self.satisfactionVerticalStackView.addArrangedSubview(self.satisfactionRatingView)
        self.difficultyVerticalStackView.addArrangedSubview(self.difficultyLabel)
        self.difficultyVerticalStackView.addArrangedSubview(self.difficultyRatingView)
        self.horizontalStackView.addArrangedSubview(self.satisfactionVerticalStackView)
        self.horizontalStackView.addArrangedSubview(self.difficultyVerticalStackView)
    }

    func configureHorizontalStackViewLayout() {
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.horizontalStackView)
        NSLayoutConstraint.activate([
            self.horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
