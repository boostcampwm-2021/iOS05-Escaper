//
//  RecordUserView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

class RecordUserView: UIView {
    enum Constant {
        static let verticalSpace = CGFloat(10)
        static let horizontalSpace = CGFloat(5)
    }

    enum Result: String {
        var name: String {
            return self.rawValue
        }

        case success
        case fail
    }

    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = CGFloat(20)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let participantLabel: UILabel = {
        let label = EDSLabel.b03R(text: "참가자", color: .gloomyPurple)
        label.textAlignment = .left
        return label
    }()
    private let nicknameLabel: UILabel = {
        let label = EDSLabel.b01B(text: "닉네임", color: .bloodyBlack)
        label.textAlignment = .left
        return label
    }()
    private let resultLabel: UILabel = {
        let label = EDSLabel.b03R(text: "Fail", color: .bloodyBlack)
        label.textAlignment = .center
        label.layer.cornerRadius = CGFloat(12)
        label.layer.masksToBounds = true
        return label
    }()
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    func update(nickname: String, result: Bool) {
        self.nicknameLabel.text = nickname
        self.resultLabel.text = result ? Result.success.name : Result.fail.name
        switch result {
        case true:
            self.resultLabel.backgroundColor = EDSColor.pumpkin.value
        case false:
            self.resultLabel.backgroundColor = EDSColor.bloodyRed.value
        }
    }
}

extension RecordUserView {
    func configureLayout() {
        configureUserImageViewLayout()
        configureHorizontalStackViewLayout()
        configureVerticalStackViewLayout()
        configureNicknameLabeLayout()
        configureResultLabelLayout()
    }

    func configureUserImageViewLayout() {
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userImageView)
        NSLayoutConstraint.activate([
            self.userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.userImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.userImageView.widthAnchor.constraint(equalTo: self.userImageView.heightAnchor)
        ])
    }

    func configureHorizontalStackViewLayout() {
        self.horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.horizontalStackView)
        self.horizontalStackView.addArrangedSubview(self.nicknameLabel)
        self.horizontalStackView.addArrangedSubview(self.resultLabel)
    }

    func configureVerticalStackViewLayout() {
        self.verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.verticalStackView)
        self.verticalStackView.addArrangedSubview(self.participantLabel)
        self.verticalStackView.addArrangedSubview(self.horizontalStackView)
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.verticalSpace),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: Constant.verticalSpace),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.verticalSpace),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constant.verticalSpace)
        ])
    }

    func configureNicknameLabeLayout() {
        self.nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nicknameLabel.widthAnchor.constraint(equalTo: self.verticalStackView.widthAnchor, multiplier: 0.7).isActive = true
    }

    func configureResultLabelLayout() {
        self.resultLabel.translatesAutoresizingMaskIntoConstraints = false
        self.resultLabel.widthAnchor.constraint(equalTo: self.verticalStackView.widthAnchor, multiplier: 0.3).isActive = true
    }
}
