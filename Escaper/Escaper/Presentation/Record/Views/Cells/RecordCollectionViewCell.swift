//
//  RecordCollectionViewCell.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/09.
//

import UIKit

final class RecordCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: RecordCollectionViewCell.self)

    private let backgroundImageView: UIImageView = UIImageView(image: EDSImage.recordCard.value)
    private let selfyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = EDSImage.plus.value
        imageView.backgroundColor = EDSColor.charcoal.value
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let roomTitleLabel = EDSLabel.h03B(color: .charcoal)
    private let storeTitleLabel = EDSLabel.b01B(color: .charcoal)
    private let titlesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private let recordUserView: RecordUserView = RecordUserView()
    private let starDashView = UIView()
    private let recordStarView: RecordStarView = RecordStarView()
    private let resultDashView = UIView()
    private let recordResultView: RecordResultView = RecordResultView()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        button.setTitleColor(EDSColor.skullWhite.value, for: .normal)
        button.backgroundColor = EDSColor.gloomyPurple.value
        button.layer.cornerRadius = 10
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.starDashView.addDashedBorder()
        self.resultDashView.addDashedBorder()
    }

    func update(recordCard: RecordCard) {
        self.updateSelfy(imageURLString: recordCard.recordImageURLString)
        self.roomTitleLabel.text = recordCard.roomTitle
        self.storeTitleLabel.text = recordCard.storeName
        self.recordUserView.update(nickname: recordCard.username, result: recordCard.isSuccess)
        self.recordStarView.update(satisfaction: recordCard.satisfaction, difficulty: Double(recordCard.difficulty))
        self.recordResultView.update(playerRank: recordCard.rank, numberOfPlayers: recordCard.numberOfTotalPlayers, time: recordCard.time)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.recordUserView.prepareForReuse()
        self.recordStarView.prepareForReuse()
        self.recordResultView.prepareForReuse()
    }
}

private extension RecordCollectionViewCell {
    enum Constant {
        static var defaultHorizontalSpace = CGFloat(50)
        static var longHorizontalSpace = CGFloat(180)
        static var middleHorizontalSpace = CGFloat(120)
        static var shortHorizontalSpace = CGFloat(50)
        static let longVerticalSpace = CGFloat(20)
        static let middleVerticalSpace = CGFloat(15)
        static let shortVerticalSpace = CGFloat(10)
    }

    func configureLayout() {
        self.configureViewLayout()
        self.configureBackgroundImageViewLayout()
        self.configureSelfyImageViewLayout()
        self.configureAddArrangeSubViews()
        self.configureTitlesStackViewLayout()
        self.configureRecordUserViewLayout()
        self.configureStarDashViewLayout()
        self.configureRecordStarViewLayout()
        self.configureResultDashViewLayout()
        self.configureRecordResultViewLayout()
        //        self.configureShareButtonLayout()
    }

    func configureViewLayout() {
        self.backgroundColor = EDSColor.bloodyBlack.value
    }

    func configureBackgroundImageViewLayout() {
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.backgroundImageView)
        NSLayoutConstraint.activate([
            self.backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureSelfyImageViewLayout() {
        self.selfyImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.selfyImageView)
        NSLayoutConstraint.activate([
            self.selfyImageView.heightAnchor.constraint(equalTo: self.backgroundImageView.heightAnchor, multiplier: 0.2),
            self.selfyImageView.widthAnchor.constraint(equalTo: self.selfyImageView.heightAnchor),
            self.selfyImageView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor, constant: 15),
            self.selfyImageView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor)
        ])
    }

    func configureAddArrangeSubViews() {
        self.titlesStackView.addArrangedSubview(self.roomTitleLabel)
        self.titlesStackView.addArrangedSubview(self.storeTitleLabel)
    }

    func configureTitlesStackViewLayout() {
        self.titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titlesStackView)
        NSLayoutConstraint.activate([
            self.titlesStackView.topAnchor.constraint(equalTo: self.selfyImageView.bottomAnchor, constant: Constant.longVerticalSpace),
            self.titlesStackView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.titlesStackView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor)
        ])
    }

    func configureRecordUserViewLayout() {
        self.recordUserView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.recordUserView)
        NSLayoutConstraint.activate([
            self.recordUserView.topAnchor.constraint(equalTo: self.titlesStackView.bottomAnchor, constant: Constant.longVerticalSpace),
            self.recordUserView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: 0.7),
            self.recordUserView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.recordUserView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.135)
        ])
    }

    func configureStarDashViewLayout() {
        self.starDashView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.starDashView)
        NSLayoutConstraint.activate([
            self.starDashView.topAnchor.constraint(equalTo: self.recordUserView.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.starDashView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.starDashView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: 0.7),
            self.starDashView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    func configureRecordStarViewLayout() {
        self.recordStarView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.recordStarView)
        NSLayoutConstraint.activate([
            self.recordStarView.topAnchor.constraint(equalTo: self.starDashView.bottomAnchor),
            self.recordStarView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: 0.8),
            self.recordStarView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.recordStarView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.135)
        ])
    }

    func configureResultDashViewLayout() {
        self.resultDashView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.resultDashView)
        NSLayoutConstraint.activate([
            self.resultDashView.topAnchor.constraint(equalTo: self.recordStarView.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.resultDashView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.resultDashView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: 0.7),
            self.resultDashView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    func configureRecordResultViewLayout() {
        self.recordResultView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.recordResultView)
        NSLayoutConstraint.activate([
            self.recordResultView.topAnchor.constraint(equalTo: self.resultDashView.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.recordResultView.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: 0.8),
            self.recordResultView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.recordResultView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.135)
        ])
    }

    //    func configureShareButtonLayout() {
    //        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
    //        self.contentView.addSubview(self.shareButton)
    //        NSLayoutConstraint.activate([
    //            self.shareButton.topAnchor.constraint(equalTo: self.recordResultView.bottomAnchor, constant: Constant.shortVerticalSpace),
    //            self.shareButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.defaultHorizontalSpace),
    //            self.shareButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.defaultHorizontalSpace),
    //            self.shareButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.11)
    //        ])
    //    }

    func updateSelfy(imageURLString: String) {
        ImageCacheManager.shared.download(urlString: imageURLString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.selfyImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension UIView {
    func addDashedBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = EDSColor.skullWhite.value?.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [2, 3]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: 0),
                                CGPoint(x: self.frame.width, y: 0)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
