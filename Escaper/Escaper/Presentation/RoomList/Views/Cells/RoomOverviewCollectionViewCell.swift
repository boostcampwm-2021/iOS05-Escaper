//
//  RoomOverviewCollectionViewCell.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/04.
//

import UIKit

final class RoomOverviewCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: ColorPalette.skullLightWhite.name)
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    private let ratingContainerView = RatingContainerView()

    func update() {
        self.genreImageView.image = UIImage(named: Genre.adventure.previewImageAssetName)
        self.titleLabel.text = "하이하이하이하이하이하이하이하이하이하이하이"
        self.ratingContainerView.update()
    }

    override func prepareForReuse() {
        self.genreImageView.image = nil
        self.titleLabel.text = ""
        self.ratingContainerView.prepareForReuse()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.genreImageView.layer.cornerRadius = self.genreImageView.bounds.width/2
    }
}

private extension RoomOverviewCollectionViewCell {
    func configure() {
        self.configureCell()
        self.configureGenreImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureRatingContainerViewLayout()
    }

    func configureCell() {
        self.backgroundColor = UIColor(named: ColorPalette.gloomyBrown.name)
    }

    func configureGenreImageViewLayout() {
        self.genreImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.genreImageView)
        NSLayoutConstraint.activate([
            self.genreImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.genreImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.genreImageView.heightAnchor.constraint(equalToConstant: 40),
            self.genreImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.genreImageView.trailingAnchor, constant: 10),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    func configureRatingContainerViewLayout() {
        self.ratingContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.ratingContainerView)
        NSLayoutConstraint.activate([
            self.ratingContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.ratingContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.ratingContainerView.heightAnchor.constraint(equalToConstant: 30),
            self.ratingContainerView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
