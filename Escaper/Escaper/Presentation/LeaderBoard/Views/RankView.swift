//
//  RankView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/16.
//

import UIKit

final class RankView: UIView {
    static let rankColor = [EDSColor.pumpkin.value, EDSColor.gloomyPink.value, EDSColor.gloomyRed.value]

    private let imageView = UIImageView()
    private let rankNumberLabel: UILabel = {
        let label = EDSLabel.b01B(color: .bloodyBlack)
        label.textAlignment = .center
        return label
    }()
    private let userNameLabel = EDSLabel.b01B(color: .skullLightWhite)

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
        self.imageView.layer.borderWidth = 6
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = self.imageView.frame.width/2
        self.rankNumberLabel.layer.masksToBounds = true
        self.rankNumberLabel.layer.cornerRadius = self.rankNumberLabel.frame.width/2
        self.rankNumberLabel.layer.borderWidth = 5
        self.rankNumberLabel.layer.borderColor = EDSColor.zombiePurple.value?.cgColor
    }

    func update(user: User, rank: Int) {
        self.rankNumberLabel.text = "\(rank + 1)"
        self.userNameLabel.text = user.name
        self.imageView.layer.borderColor = Self.rankColor[rank]?.cgColor
        self.rankNumberLabel.backgroundColor = Self.rankColor[rank]
        ImageCacheManager.shared.download(urlString: user.imageURL, completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}

private extension RankView {
    func configureLayout() {
        self.configureImageViewLayout()
        self.configureRankNumberLabelLayout()
        self.configureUserNameLabelLayout()
    }

    func configureImageViewLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor)
        ])
    }

    func configureRankNumberLabelLayout() {
        self.rankNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.rankNumberLabel)
        NSLayoutConstraint.activate([
            self.rankNumberLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.rankNumberLabel.widthAnchor.constraint(equalToConstant: 32),
            self.rankNumberLabel.heightAnchor.constraint(equalTo: self.rankNumberLabel.widthAnchor),
            self.rankNumberLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -16)
        ])
    }

    func configureUserNameLabelLayout() {
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userNameLabel)
        NSLayoutConstraint.activate([
            self.userNameLabel.centerXAnchor.constraint(equalTo: self.rankNumberLabel.centerXAnchor),
            self.userNameLabel.topAnchor.constraint(equalTo: self.rankNumberLabel.bottomAnchor, constant: 4)
        ])
    }
}
