//
//  LoginViewController.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/16.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func loginSuccessed()
}

class LoginViewController: DefaultViewController {
    enum Constant {
        static let shortHorizontalSpace = CGFloat(30)
        static let middleHorizontalSpace = CGFloat(60)
        static let longHorizontalSpace = CGFloat(90)
        static let shortVerticalSpace = CGFloat(20)
        static let middleVerticalSpace = CGFloat(60)
        static let longVerticalSpace = CGFloat(75)
        static let textFieldHeight = CGFloat(60)
        static let defaultSpace = CGFloat(15)
        static let loginButtonHeight = CGFloat(45)
    }

    private weak var delegate: LoginViewControllerDelegate?

    private var viewModel: LoginViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
        self.bindViewModel()
    }

    func create(delegate: LoginViewControllerDelegate) {
        let userRepository = UserRepository(service: FirebaseService.shared)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = DefaultLoginViewModel(usecase: userUsecase)
        self.viewModel = viewModel
        self.delegate = delegate
    }

    func bindViewModel() {
        self.viewModel?.emailMessage.observe(on: self) { [weak self] text in
            self?.emailInputView.guideWordsLabel.text = self?.viewModel?.emailMessage.value
        }
        self.viewModel?.passwordMessage.observe(on: self) { [weak self] text in
            self?.passwordInputView.guideWordsLabel.text = self?.viewModel?.passwordMessage.value
        }
    }

    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(EDSColor.bloodyBurgundy.value, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
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

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()

    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func loginButtonTapped() {
        guard let email = self.emailInputView.textField?.text,
              let password = self.passwordInputView.textField?.text else { return }
        self.viewModel?.confirmUser(email: email, password: password) { result in
            switch result {
            case .success(let user):
                let imageURLString = user.imageURL
                UserSupervisor.shared.login(email: email, imageURLString: imageURLString)
                self.delegate?.loginSuccessed()
                self.dismiss(animated: true)
            case .failure(.notExist):
                self.designateSignupButtonState()
            case .failure(.networkUnconneted):
                print(UserError.networkUnconneted)
            }
        }
    }

    func designateSignupButtonState() {
        guard let viewModel = self.viewModel else { return }
        if viewModel.isLoginButtonEnabled() {
            self.loginButton.backgroundColor = EDSColor.pumpkin.value
            self.loginButton.isEnabled = true
        } else {
            self.loginButton.backgroundColor = EDSColor.gloomyPurple.value
            self.loginButton.isEnabled = false
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.viewModel?.startEditing()
        self.designateSignupButtonState()
    }
}

extension LoginViewController {
    func configure() {
        self.emailInputView.injectDelegate(self)
        self.passwordInputView.injectDelegate(self)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
    }

    func configureLayout() {
        self.configureCancelButtonLayout()
        self.configurePumpkinImageViewLayout()
        self.configureLoginLabelLayout()
        self.configureEmailInputViewLayout()
        self.configurePasswordInputViewLayout()
        self.configureLoginButtonLayout()
    }

    func configureCancelButtonLayout() {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.cancelButton)
        NSLayoutConstraint.activate([
            self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constant.defaultSpace),
            self.cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.defaultSpace)
        ])
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

    func configureLoginButtonLayout() {
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constant.middleVerticalSpace),
            self.loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace),
            self.loginButton.heightAnchor.constraint(equalToConstant: Constant.loginButtonHeight)
        ])
    }
}
