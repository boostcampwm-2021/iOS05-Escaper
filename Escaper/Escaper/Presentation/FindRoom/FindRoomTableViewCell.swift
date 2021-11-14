//
//  FindRoomTableViewCell.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/10.
//

import UIKit

class FindRoomTableViewCell: UITableViewCell {
    static let identifier = String(describing: RoomOverviewTableViewCell.self)

    private let titleLabel = EDSLabel.b01B(color: .pumpkin)
    private let storeNameLabel = EDSLabel.b03R(color: .skullLightWhite)
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
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

    func update(_ room: Room) {
        self.titleLabel.text = room.name
        self.storeNameLabel.text = room.storeName
    }
}

private extension FindRoomTableViewCell {
    func configure() {
        self.configureStackViewLayout()
        self.clearBackgroundSelectedCell()
    }

    func configureStackViewLayout() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.storeNameLabel)
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }

    func clearBackgroundSelectedCell() {
        let bgColorView = UIView()
        bgColorView.backgroundColor = .clear
        self.selectedBackgroundView = bgColorView
        self.backgroundColor = .clear
    }
}
