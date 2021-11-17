//
//  LeaderBoardViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

final class LeaderBoardViewController: DefaultViewController {
    var dummyUsers = [User.init(email: "abc", name: "신희", password: "1", imageURL: nil, score: 1), User.init(email: "완식", name: "완식", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "택현", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "영광", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "a", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "a", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "a", password: "1", imageURL: nil, score: 1), User.init(email: "abc", name: "a", password: "1", imageURL: nil, score: 1)]

    private let scrollView = UIScrollView()
    private let titleLabel = EDSLabel.h02B(text: "리더보드", color: .skullLightWhite)
    private let topRankView = TopRankView()
    private let userRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.update()
    }

    func create() {
        // 의존성 주입
    }

}

private extension LeaderBoardViewController {
    func configureLayout() {
        self.configureTitleLabelLayout()
        self.configureScrollViewLayout()
        self.configureTopRankViewLayout()
        self.configureUserRankStackViewLayout()
    }

    func configureScrollViewLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor, constant: 16),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.centerXAnchor)
        ])
    }

    func configureTopRankViewLayout() {
        self.topRankView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.topRankView)
        NSLayoutConstraint.activate([
            self.topRankView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16),
            self.topRankView.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            self.topRankView.trailingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            self.topRankView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7)
        ])
    }

    func configureUserRankStackViewLayout() {
        self.userRankStackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.userRankStackView)
        NSLayoutConstraint.activate([
            self.userRankStackView.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            self.userRankStackView.trailingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            self.userRankStackView.topAnchor.constraint(equalTo: self.topRankView.bottomAnchor),
            self.userRankStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    func update() {
        self.updateTopRankView()
        self.updateStackView()
    }

    func updateTopRankView() {
        self.topRankView.update(users: Array(self.dummyUsers.prefix(3)))
    }

    func updateStackView() {
        for (rank, userInfo) in self.dummyUsers.enumerated() {
            let rankView = RoomDetailUserRankView()
            rankView.translatesAutoresizingMaskIntoConstraints = false
            rankView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            rankView.layer.cornerRadius = 30
            rankView.update(userInfo, rank: rank)
            self.userRankStackView.addArrangedSubview(rankView)
        }
    }
}
