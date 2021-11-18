//
//  RatingView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

final class RatingView: UIView {
    enum Constant {
        static let spacing = CGFloat(3)
        static let summationOfElementSpacing = Constant.spacing * CGFloat(Rating.maxRating - 1)
    }

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.spacing
        return stackView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
        self.configureZeroRating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
        self.configureZeroRating()
    }

    func fill(rating: Rating) {
        (0..<Rating.maxRating).forEach { index in
            guard let imageView = self.stackView.arrangedSubviews[index] as? UIImageView else { return }
            imageView.image = index < rating.value ? Image.filled : Image.unfilled
        }
    }
}

private extension RatingView {
    enum Image {
        static let filled = UIImage(named: RatingImage.starFilled.name)
        static let unfilled = UIImage(named: RatingImage.starUnfilled.name)
    }

    func configureLayout() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureZeroRating() {
        (0..<Rating.maxRating).forEach { _ in
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: RatingImage.starUnfilled.name)
            self.stackView.addArrangedSubview(starImageView)
        }
    }
}
