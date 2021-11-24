//
//  RecordGuideView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/23.
//

import UIKit

class RecordGuideView: UIView {
    enum Constant {
        static let imageLengthRatio = CGFloat(0.5)
        static let tinyVerticalSpace = CGFloat(5)
        static let smallVerticalSpace = CGFloat(10)
        static let normalVerticalSpace = CGFloat(20)
        static let bigVerticalSpace = CGFloat(50)
        static let buttonWidthRatio = CGFloat(0.65)
        static let buttonHeightRatio = CGFloat(0.1)
    }

    private(set) var backgroundImageView = UIImageView(image: EDSImage.recordCard.value)
    private(set) var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private(set) var titleLabel: UILabel = {
        let label = EDSLabel.h03B(color: .bloodyBlack)
        label.contentMode = .center
        return label
    }()
    private(set) var descriptionLabel: UILabel = {
        let label = EDSLabel.b02L(color: .gloomyPurple)
        label.contentMode = .center
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    func inject(mainImage: UIImage?, title: String, description: String) {
        self.mainImageView.image = mainImage
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}

private extension RecordGuideView {
    func configure() {
        self.configureBackgroundImageViewLayout()
        self.configureMainImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureDescriptionLabelLayout()
    }

    func configureBackgroundImageViewLayout() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.backgroundImageView)
        NSLayoutConstraint.activate([
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureMainImageViewLayout() {
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.mainImageView)
        NSLayoutConstraint.activate([
            self.mainImageView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: Constant.bigVerticalSpace),
            self.mainImageView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: Constant.imageLengthRatio),
            self.mainImageView.heightAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: Constant.imageLengthRatio),
            self.mainImageView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.mainImageView.bottomAnchor, constant: Constant.normalVerticalSpace)
        ])
    }

    func configureDescriptionLabelLayout() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.smallVerticalSpace),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor)
        ])
    }
}

