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
        let label = EDSLabel.h01B(text: "리더보드", color: .skullWhite)
        label.accessibilityTraits = .header
        label.accessibilityHint = "리더보드화면은 스크롤로 되어있습니다. 상단에 1위부터 3위까지 하단에 1위부터 10위까지 유저 정보가 있습니다."
        return label
    }()

    private let topRankView = TopRankView()
    private let userRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 13
        stackView.distribution = .fill
        return stackView
    }()
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let text = "당겨서 새로고침"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: EDSColor.skullWhite.value ?? UIColor.white, range: (text as NSString).range(of: text))
        refreshControl.attributedTitle = attributedString
        refreshControl.tintColor = EDSColor.skullWhite.value
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureLayout()
        self.update()
        self.bindViewModel()
    }

    func create(viewModel: LeaderBoardViewModelInterface) {
        self.viewModel = viewModel
    }
}

private extension LeaderBoardViewController {
    func configureLayout() {
        self.configureTitleLabelLayout()
        self.configureScrollViewLayout()
        self.configureTopRankViewLayout()
        self.configureUserRankStackViewLayout()
        self.configureRefreshControl()
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }

    func configureScrollViewLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureTopRankViewLayout() {
        self.topRankView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.topRankView)
        NSLayoutConstraint.activate([
            self.topRankView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
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
            self.userRankStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    func configureRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        self.scrollView.refreshControl = self.refreshControl
    }

    func bindViewModel() {
        self.viewModel?.users.observe(on: self, observerBlock: { [weak self] users in
            self?.topRankView.update(users: users.prefix(3).map {$0})
            self?.updateStackView(users: users.prefix(10).map {$0})
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: { [weak self] in
                    self?.refreshControl.endRefreshing()
            })
        })
    }

    func update() {
        self.viewModel?.fetch()
    }

    func updateStackView(users: [User]) {
        self.userRankStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (rank, user) in users.enumerated() {
            let rankView = RoomDetailUserRankView()
            rankView.translatesAutoresizingMaskIntoConstraints = false
            rankView.heightAnchor.constraint(equalToConstant: 60).isActive = true
            rankView.layer.cornerRadius = 10
            rankView.update(user, rank: rank)
            rankView.isAccessibilityElement = true
            rankView.accessibilityLabel = "\(rank + 1)등 \(user.name)님 \(user.score)점"
            self.userRankStackView.addArrangedSubview(rankView)
        }
    }

    @objc func refresh(sender: UIRefreshControl) {
        self.update()
    }
}
