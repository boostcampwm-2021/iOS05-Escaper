//
//  RecordDefaultGuideView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

protocol RecordDefaultGuideViewDelegate: AnyObject {
    func loginButtonTouched()
    func signUpButtonTouched()
}

final class RecordDefaultGuideView: RecordGuideView {
    weak var delegate: RecordDefaultGuideViewDelegate?

    private var guideStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    private var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.backgroundColor = EDSColor.pumpkin.value
        button.layer.cornerRadius = CGFloat(20)
        button.layer.masksToBounds = true
        return button
    }()
    private var guideLabel: UILabel = EDSLabel.b02R(text: "계정이 없으신가요?", color: EDSColor.gloomyPurple)
    private var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
}

private extension RecordDefaultGuideView {
    enum Content {
        static let title = "기록장이 잠겨있어요."
        static let description = """
        로그인 후 방탈출 기록을 남겨보세요.
        다녀온 방에서 내 랭킹도 확인할 수 있답니다.
        """
    }

    func configure() {
        self.configureLoginButtonLayout()
        self.configureStackViewLayout()
        self.configureLoginButton()
        self.configureSignupButton()
        self.configureStackView()
        super.inject(mainImage: EDSImage.recordBook.value, title: Content.title, description: Content.description)
    }

    func configureLoginButtonLayout() {
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.loginButton.widthAnchor.constraint(equalTo: self.backgroundImageView.widthAnchor, multiplier: Constant.buttonWidthRatio),
            self.loginButton.heightAnchor.constraint(equalTo: self.backgroundImageView.heightAnchor, multiplier: Constant.buttonHeightRatio)
        ])
    }

    func configureStackViewLayout() {
        self.guideStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.guideStackView)
        NSLayoutConstraint.activate([
            self.guideStackView.centerXAnchor.constraint(equalTo: self.backgroundImageView.centerXAnchor),
            self.guideStackView.topAnchor.constraint(equalTo: self.loginButton.bottomAnchor, constant: Constant.tinyVerticalSpace),
            self.guideStackView.bottomAnchor.constraint(equalTo: self.backgroundImageView.bottomAnchor, constant: -Constant.bigVerticalSpace)
        ])
    }

    func configureLoginButton() {
        self.loginButton.addTarget(self, action: #selector(loginButtonTouched(sender:)), for: .touchUpInside)
    }

    func configureSignupButton() {
        self.signupButton.addTarget(self, action: #selector(self.signUpButtonTouched(sender:)), for: .touchUpInside)
    }

    func configureStackView() {
        self.guideStackView.addArrangedSubview(self.guideLabel)
        self.guideStackView.addArrangedSubview(self.signupButton)
    }

    @objc func loginButtonTouched(sender: UIButton) {
        self.delegate?.loginButtonTouched()
    }

    @objc func signUpButtonTouched(sender: UIButton) {
        self.delegate?.signUpButtonTouched()
    }
}
