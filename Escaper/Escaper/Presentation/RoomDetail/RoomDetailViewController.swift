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
    private let titleLabel: UILabel = {
        let label = EDSLabel.h01B(color: .skullLightWhite)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let storeNameLabel = EDSLabel.b01R(color: .skullGrey)
    private let descriptionLabel: UILabel = {
        let label = EDSLabel.b01R(color: .skullLightWhite)
        label.numberOfLines = 4
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let roomDetailInfoVeiw = RoomDetailInfoView()
    private let rankTitleLabel = EDSLabel.h01B(text: "TOP 3", color: .skullLightWhite)
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
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: EDSImage.share.value, style: .plain, target: self, action: #selector(self.shareButtonTouched))
    }
}

private extension RoomDetailViewController {
    enum Constant {
        static let stackViewSpace = CGFloat(10)
        static let rankViewHeight = CGFloat(60)
        static let genreImageSize = CGFloat(180)
        static let shortVerticalSpace = CGFloat(8)
        static let longVerticalSpace = CGFloat(24)
        static let verticalSpace = CGFloat(16)
        static let horizontalSpace = CGFloat(20)
        static let DetailInfoHeight = CGFloat(100)
    }

    func configureLayout() {
        self.configureScrollViewLayout()
        self.configureGenreImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureStoreNameLabelLayout()
        self.configureDescriptionLabelLayout()
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
            self.titleLabel.topAnchor.constraint(equalTo: self.genreImageView.bottomAnchor, constant: Constant.longVerticalSpace),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: Constant.horizontalSpace),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.trailingAnchor, constant: -Constant.horizontalSpace)
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

    func configureDescriptionLabelLayout() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.storeNameLabel.centerXAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.genreImageView.widthAnchor, multiplier: 1.2),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.storeNameLabel.bottomAnchor, constant: Constant.shortVerticalSpace)
        ])
    }

    func configureRoomDetailInfoViewLayout() {
        self.roomDetailInfoVeiw.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.roomDetailInfoVeiw)
        NSLayoutConstraint.activate([
            self.roomDetailInfoVeiw.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: Constant.longVerticalSpace),
            self.roomDetailInfoVeiw.leadingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.leadingAnchor, constant: Constant.horizontalSpace),
            self.roomDetailInfoVeiw.trailingAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.trailingAnchor, constant: -Constant.horizontalSpace),
            self.roomDetailInfoVeiw.heightAnchor.constraint(equalToConstant: Constant.DetailInfoHeight)
        ])
    }

    func configureRankTitleLabelLayout() {
        self.rankTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.rankTitleLabel)
        NSLayoutConstraint.activate([
            self.rankTitleLabel.topAnchor.constraint(equalTo: self.roomDetailInfoVeiw.bottomAnchor, constant: Constant.verticalSpace),
            self.rankTitleLabel.leadingAnchor.constraint(equalTo: self.roomDetailInfoVeiw.leadingAnchor)
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
        self.descriptionLabel.text = room.description
        self.genreImageView.isAccessibilityElement = true
        self.genreImageView.accessibilityLabel = "테마 종류 \(room.genre.name)"
    }

    func updateStackView(records: [Record]) {
        self.rankTitleLabel.isHidden = records.isEmpty
        for (rank, record) in records.sorted(by: { $0.escapingTime < $1.escapingTime }).prefix(3).enumerated() {
            let rankView = RoomDetailUserRankView()
            rankView.translatesAutoresizingMaskIntoConstraints = false
            rankView.heightAnchor.constraint(equalToConstant: Constant.rankViewHeight).isActive = true
            rankView.layer.cornerRadius = 10
            rankView.update(record, rank: rank)
            self.userRankStackView.addArrangedSubview(rankView)
        }
    }

    @objc func shareButtonTouched() {
        guard let image = self.view.transformToImage() else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.saveToCameraRoll]
        self.present(activityViewController, animated: true, completion: nil)
    }
}
