//
//  StoreOverViewTableViewCell.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/21.
//

import UIKit

class StoreOverViewTableViewCell: UITableViewCell {
    static let identifier = String(describing: StoreOverViewTableViewCell.self)

    private let storeTitleLabel: UILabel = {
        let label = EDSLabel.b01B(color: .skullLightWhite)
        label.lineBreakMode = .byWordWrapping
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let regionStackView: StoreInformationStackView = {
        let stackView = StoreInformationStackView()
        stackView.setColor(EDSColor.pumpkin.value)
        stackView.setImage(EDSSystemImage.mappin.value)
        return stackView
    }()
    private let genreStackView: StoreInformationStackView = {
        let stackView = StoreInformationStackView()
        stackView.setColor(EDSColor.pumpkin.value)
        stackView.setImage(EDSImage.genreIcon.value)
        return stackView
    }()
    private let distanceStackView: StoreInformationStackView = {
        let stackView = StoreInformationStackView()
        stackView.setColor(EDSColor.skullGrey.value)
        stackView.setImage(EDSImage.distanceIcon.value)
        return stackView
    }()
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20))
    }

    func update(_ store: Store) {
        self.storeTitleLabel.text = store.name
        self.regionStackView.setTitle(store.region.krName)
        self.genreStackView.setTitle("\(store.roomIds.count)개 테마")
        self.distanceStackView.setTitle("\(Helper.measureDistance(store.distance))")
    }
}

private extension StoreOverViewTableViewCell {
    func configure() {
        self.configureCell()
        self.configureStoreTitleLabelLayout()
        self.configureInformationStackView()
        self.configureDistanceStackView()
    }

    func configureCell() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = EDSColor.gloomyBrown.value
    }

    func configureStoreTitleLabelLayout() {
        self.storeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.storeTitleLabel)
        NSLayoutConstraint.activate([
            self.storeTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.storeTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15)
        ])
    }

    func configureInformationStackView() {
        self.informationStackView.addArrangedSubview(self.regionStackView)
        self.informationStackView.addArrangedSubview(self.genreStackView)
        self.informationStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.informationStackView)
        NSLayoutConstraint.activate([
            self.informationStackView.topAnchor.constraint(equalTo: self.storeTitleLabel.bottomAnchor, constant: 10),
            self.informationStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.informationStackView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4)
        ])
    }

    func configureDistanceStackView() {
        self.distanceStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.distanceStackView)
        NSLayoutConstraint.activate([
            self.distanceStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.distanceStackView.bottomAnchor.constraint(equalTo: self.informationStackView.bottomAnchor)
        ])
    }
}
