//
//  UserSettingView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/25.
//

import UIKit

class UserSettingView: UIView {
    enum RegisterAppearance {
        case login
        case logout
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = EDSLabel.b01B(color: .skullLightWhite)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()
    private(set) var registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = EDSColor.bloodyRed.value
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.layer.masksToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageView.layer.cornerRadius = self.imageView.bounds.height/2
        self.registerButton.layer.cornerRadius = self.registerButton.bounds.height/2
    }

    func inject(image: UIImage?, title: String) {
        self.imageView.image = image
        self.titleLabel.text = title
    }

    func changeButtonAppearance(appearance: RegisterAppearance) {
        switch appearance {
        case .login:
            self.registerButton.setTitle("로그인", for: .normal)
            self.registerButton.setTitleColor(EDSColor.charcoal.value, for: .normal)
            self.registerButton.backgroundColor = EDSColor.pumpkin.value
        case .logout:
            self.registerButton.setTitle("로그아웃", for: .normal)
            self.registerButton.setTitleColor(EDSColor.skullWhite.value, for: .normal)
            self.registerButton.backgroundColor = EDSColor.gloomyRed.value
        }
    }
}

private extension UserSettingView {
    enum Constant {
        static let sideSpace = CGFloat(20)
        static let horizontalSmallSpace = CGFloat(10)
        static let cornerRadius = CGFloat(10)
        static let buttonHeightRatio = CGFloat(0.4)
    }

    func configure() {
        self.configureAppearance()
        self.configureImageViewLayout()
        self.configureTitleLabelLayout()
        self.configureRegisterButtonLayout()
    }

    func configureAppearance() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constant.cornerRadius
        self.backgroundColor = EDSColor.gloomyBrown.value
    }

    func configureImageViewLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            self.imageView.widthAnchor.constraint(equalTo: self.imageView.heightAnchor)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Constant.horizontalSmallSpace),
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6)
        ])
    }

    func configureRegisterButtonLayout() {
        self.registerButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.registerButton)
        NSLayoutConstraint.activate([
            self.registerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.registerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.sideSpace),
            self.registerButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.buttonHeightRatio),
            self.registerButton.widthAnchor.constraint(equalTo: self.registerButton.heightAnchor, multiplier: 2.5)
        ])
    }
}
