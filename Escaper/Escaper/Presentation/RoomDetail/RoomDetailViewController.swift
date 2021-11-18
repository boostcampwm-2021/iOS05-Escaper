//
//  RoomDetailViewController.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/09.
//

import UIKit

final class RoomDetailViewController: DefaultViewController {
    var room: Room?
    private let scrollView = UIScrollView()
    private let genreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let titleLabel = EDSLabel.h01B(color: .skullLightWhite)
    private let storeNameLabel = EDSLabel.b01R(color: .skullGrey)
    private let roomDetailInfoVeiw = RoomDetailInfoView()
    private let rankTitleLabel = EDSLabel.h01B(text: "이 방의 TOP3!", color: .skullLightWhite)
    private let userRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.stackViewSpace
        stackView.distribution = .fill
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let room = room else { return }
        self.configureLayout()
        self.update(room: room)
        self.roomDetailInfoVeiw.update(room: room)
        self.updateStackView(records: room.records)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}

private extension RoomDetailViewController {
    enum Constant {
        static let stackViewSpace: CGFloat = 10
        static let rankViewHeight: CGFloat = 60
        static let genreImageSize: CGFloat = 180
        static let shortVerticalSpace: CGFloat = 4
        static let longVerticalSpace: CGFloat = 24
        static let verticalSpace: CGFloat = 16
        static let horizontalSpace: CGFloat = 20
        static let DetailInfoHeight: CGFloat = 160
        static let DetailInfoSideSpace: CGFloat = 60
    }
    
    func configureLayout() {
        self.configureScrollViewLayout()
        self.configureGenreImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureStoreNameLabelLayout()
        self.configureRoomDetailInfoViewLayout()
        self.configureRankTitleLabelLayout()
        self.configureRankStackViewLayout()
    }

    func configureScrollViewLayout() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        NSLayoutConstraint.activate([
            self.scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureGenreImageViewLayout() {
        self.genreImageView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.genreImageView)
        NSLayoutConstraint.activate([
            self.genreImageView.centerXAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.centerXAnchor),
            self.genreImageView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor, constant: 32),
            self.genreImageView.widthAnchor.constraint(equalToConstant: Constant.genreImageSize),
            self.genreImageView.heightAnchor.constraint(equalToConstant: Constant.genreImageSize)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.genreImageView.bottomAnchor, constant: Constant.longVerticalSpace)
        ])
    }

    func configureStoreNameLabelLayout() {
        self.storeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.storeNameLabel)
        NSLayoutConstraint.activate([
            self.storeNameLabel.centerXAnchor.constraint(equalTo: self.titleLabel.centerXAnchor),
            self.storeNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.shortVerticalSpace)
        ])
    }

    func configureRoomDetailInfoViewLayout() {
        self.roomDetailInfoVeiw.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.roomDetailInfoVeiw)
        NSLayoutConstraint.activate([
            self.roomDetailInfoVeiw.topAnchor.constraint(equalTo: self.storeNameLabel.bottomAnchor, constant: Constant.verticalSpace),
            self.roomDetailInfoVeiw.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: Constant.DetailInfoSideSpace),
            self.roomDetailInfoVeiw.heightAnchor.constraint(equalToConstant: Constant.DetailInfoHeight)
        ])
    }

    func configureRankTitleLabelLayout() {
        self.rankTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rankTitleLabel)
        NSLayoutConstraint.activate([
            self.rankTitleLabel.topAnchor.constraint(equalTo: self.roomDetailInfoVeiw.bottomAnchor, constant: Constant.verticalSpace),
            self.rankTitleLabel.centerXAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.centerXAnchor)
        ])
    }

    func configureRankStackViewLayout() {
        self.userRankStackView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.userRankStackView)
        NSLayoutConstraint.activate([
            self.userRankStackView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: -Constant.verticalSpace),
            self.userRankStackView.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: Constant.horizontalSpace),
            self.userRankStackView.trailingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.trailingAnchor, constant: -Constant.horizontalSpace),
            self.userRankStackView.topAnchor.constraint(equalTo: self.rankTitleLabel.bottomAnchor, constant: Constant.verticalSpace)
        ])
    }

    func update(room: Room) {
        self.genreImageView.image = UIImage(named: room.genre.detailImageAssetName)
        self.titleLabel.text = room.title
        self.storeNameLabel.text = room.storeName
    }

    func updateStackView(records: [Record]) {
        self.rankTitleLabel.isHidden = records.isEmpty
        for (rank, record) in records.sorted(by: { $0.escapingTime < $1.escapingTime }).prefix(3).enumerated() {
            let rankView = RoomDetailUserRankView()
            rankView.translatesAutoresizingMaskIntoConstraints = false
            rankView.heightAnchor.constraint(equalToConstant: Constant.rankViewHeight).isActive = true
            rankView.layer.cornerRadius = Constant.rankViewHeight/2
            rankView.update(record, rank: rank)
            self.userRankStackView.addArrangedSubview(rankView)
        }
    }
}
