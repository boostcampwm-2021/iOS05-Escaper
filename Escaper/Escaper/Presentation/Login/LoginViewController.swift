//
//  LoginViewController.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/16.
//

import UIKit

class LoginViewController: DefaultViewController {
    enum Constant {
        static let shortHorizontalSpace = CGFloat(30)
        static let middleHorizontalSpace = CGFloat(60)
        static let longHorizontalSpace = CGFloat(90)
        static let shortVerticalSpace = CGFloat(20)
        static let middleVerticalSpace = CGFloat(60)
        static let longVerticalSpace = CGFloat(75)
        static let textFieldHeight = CGFloat(60)
        static let loginButtonHeight = CGFloat(45)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
    }

    private var pumpkinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = EDSImage.loginPumpkin.value
        return imageView
    }()
    private var loginLabel: UILabel = {
        let label = EDSLabel.h02B(text: "로그인", color: EDSColor.skullLightWhite)
        label.textAlignment = .center
        return label
    }()
    private var emailInputView: UserInputView = UserInputView(viewType: .email)
    private var passwordInputView: UserInputView = UserInputView(viewType: .password)
    private var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.backgroundColor = EDSColor.pumpkin.value
        button.layer.cornerRadius = CGFloat(20)
        button.layer.masksToBounds = true
        return button
    }()
    private var guideLabel: UILabel = EDSLabel.b02R(text: "계정이 없으신가요?", color: EDSColor.skullLightWhite)
    private var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return button
    }()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()

    @objc func signupButtonTapped() {
        self.present(SignUpViewController(), animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case self.emailInputView.textField:
            print("1")
            print(textField.text)
        case self.passwordInputView.textField:
            print("2")
            print(textField.text)
        default:
            print("what?")
        }
    }
}

extension LoginViewController {
    func configure() {
        self.configureStackView()
        self.emailInputView.injectDelegate(self)
        self.passwordInputView.injectDelegate(self)
        self.signupButton.addTarget(self, action: #selector(self.signupButtonTapped), for: .touchUpInside)
    }

    func configureLayout() {
        self.configurePumpkinImageViewLayout()
        self.configureLoginLabelLayout()
        self.configureEmailInputViewLayout()
        self.configurePasswordInputViewLayout()
        self.configureStackViewLayout()
        self.configureLoginButtonLayout()
    }

    func configureStackView() {
        self.stackView.addArrangedSubview(self.guideLabel)
        self.stackView.addArrangedSubview(self.signupButton)
    }

    func configurePumpkinImageViewLayout() {
        self.pumpkinImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.pumpkinImageView)
        NSLayoutConstraint.activate([
            self.pumpkinImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constant.longVerticalSpace),
            self.pumpkinImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.pumpkinImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace),
            self.pumpkinImageView.heightAnchor.constraint(equalTo: self.pumpkinImageView.widthAnchor, multiplier: 0.9)
        ])
    }

    func configureLoginLabelLayout() {
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginLabel)
        NSLayoutConstraint.activate([
            self.loginLabel.topAnchor.constraint(equalTo: self.pumpkinImageView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.loginLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.loginLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace)
        ])
    }

    func configureEmailInputViewLayout() {
        self.emailInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emailInputView)
        NSLayoutConstraint.activate([
            self.emailInputView.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: Constant.longVerticalSpace),
            self.emailInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.shortHorizontalSpace),
            self.emailInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.shortHorizontalSpace),
            self.emailInputView.heightAnchor.constraint(equalToConstant: Constant.textFieldHeight)
        ])
    }

    func configurePasswordInputViewLayout() {
        self.passwordInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.passwordInputView)
        NSLayoutConstraint.activate([
            self.passwordInputView.topAnchor.constraint(equalTo: self.emailInputView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.passwordInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.shortHorizontalSpace),
            self.passwordInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.shortHorizontalSpace),
            self.passwordInputView.heightAnchor.constraint(equalToConstant: Constant.textFieldHeight)
        ])
    }

    func configureStackViewLayout() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constant.longVerticalSpace),
            self.stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    func configureLoginButtonLayout() {
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.bottomAnchor.constraint(equalTo: self.stackView.topAnchor, constant: -Constant.shortVerticalSpace),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace),
            self.loginButton.heightAnchor.constraint(equalToConstant: Constant.loginButtonHeight)
        ])
    }
}
