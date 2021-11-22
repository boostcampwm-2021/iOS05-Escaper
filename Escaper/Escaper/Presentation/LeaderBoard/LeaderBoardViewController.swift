//
//  LeaderBoardViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

final class LeaderBoardViewController: DefaultViewController {
    private var viewModel: LeaderBoardViewModelInterface?
    private let scrollView = UIScrollView()
    private let titleLabel: UILabel = {
        let label = EDSLabel.h02B(text: "리더보드", color: .skullLightWhite)
        label.accessibilityTraits = .header
        label.accessibilityHint = "리더보드화면은 스크롤로 되어있습니다. 상단에 1위부터 3위까지 하단에 1위부터 10위까지 유저 정보가 있습니다."
        return label
    }()

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
        let repository = LeaderBoardRepository(service: FirebaseService.shared)
        let usecase = LeaderBoardUseCase(repository: repository)
        let viewModel = DefaultLeadeBoardViewModel(usecase: usecase)
        self.viewModel = viewModel
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
        self.topRankView.update(users: Array(self.viewModel.prefix(3)))
    }

    func updateStackView() {
        for (rank, user) in self.viewModel.prefix(10).enumerated() {
            let rankView = RoomDetailUserRankView()
            rankView.translatesAutoresizingMaskIntoConstraints = false
            rankView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            rankView.layer.cornerRadius = 30
            rankView.update(user, rank: rank)
            rankView.isAccessibilityElement = true
            rankView.accessibilityLabel = "전체 \(self.viewModel.count)명 중 \(rank + 1)등 \(user.name)님 \(user.score)점"
            self.userRankStackView.addArrangedSubview(rankView)
        }
    }
}
