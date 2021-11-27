//
//  TopRankView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/16.
//

import UIKit

final class TopRankView: UIView {
    private let crownImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = EDSImage.crown.value
        imageView.isHidden = true
        return imageView
    }()
    private let firstView: RankView = {
        let rankView = RankView()
        rankView.isHidden = true
        return rankView
    }()
    private let secondView: RankView = {
        let rankView = RankView()
        rankView.isHidden = true
        return rankView
    }()
    private let thirdView: RankView = {
        let rankView = RankView()
        rankView.isHidden = true
        return rankView
    }()
    private let topThree: [RankView]

    override init(frame: CGRect) {
        self.topThree = [firstView, secondView, thirdView]
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        self.topThree = [firstView, secondView, thirdView]
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(users: [User]) {
        if users.isNotEmpty {
            self.crownImageView.isHidden = false
        }
        for (rank, userInfo) in users.enumerated() {
            self.topThree[rank].isAccessibilityElement = true
            self.topThree[rank].update(user: userInfo, rank: rank)
            self.topThree[rank].accessibilityLabel = "상위 유저 3명중 \(rank + 1)등 \(userInfo.name)님"
            self.topThree[rank].isHidden = false
        }
    }
}

private extension TopRankView {
    func configureLayout() {
        self.firstViewLayout()
        self.secondViewLayout()
        self.thirdViewLayout()
        self.crownImageViewLayout()
    }

    func firstViewLayout() {
        self.firstView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.firstView)
        NSLayoutConstraint.activate([
            self.firstView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.firstView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.firstView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.35),
            self.firstView.heightAnchor.constraint(equalTo: self.firstView.widthAnchor, multiplier: 1.5)
        ])
    }

    func secondViewLayout() {
        self.secondView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.secondView)
        NSLayoutConstraint.activate([
            self.secondView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.secondView.heightAnchor.constraint(equalTo: self.secondView.widthAnchor, multiplier: 1.5),
            self.secondView.trailingAnchor.constraint(equalTo: self.firstView.leadingAnchor, constant: -16),
            self.secondView.centerYAnchor.constraint(equalTo: self.firstView.centerYAnchor)
        ])
    }

    func thirdViewLayout() {
        self.thirdView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.thirdView)
        NSLayoutConstraint.activate([
            self.thirdView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.thirdView.heightAnchor.constraint(equalTo: self.secondView.widthAnchor, multiplier: 1.5),
            self.thirdView.leadingAnchor.constraint(equalTo: self.firstView.trailingAnchor, constant: 16),
            self.thirdView.centerYAnchor.constraint(equalTo: self.firstView.centerYAnchor)
        ])
    }

    func crownImageViewLayout() {
        self.crownImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.crownImageView)
        NSLayoutConstraint.activate([
            self.crownImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25),
            self.crownImageView.heightAnchor.constraint(equalTo: self.crownImageView.widthAnchor),
            self.crownImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.crownImageView.bottomAnchor.constraint(equalTo: firstView.topAnchor, constant: 24)
        ])
    }
}
