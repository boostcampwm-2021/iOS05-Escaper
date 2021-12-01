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
        static let shortVerticalSpace = CGFloat(20)
        static let middleVerticalSpace = CGFloat(40)
        static let longVerticalSpace = CGFloat(75)
        static let defaultSpace = CGFloat(15)
        static let loginButtonHeight = CGFloat(50)
        static let inputViewWidthRatio = CGFloat(0.8)
        static let inputViewHeightRatio = CGFloat(0.1)
        static let middleWidthRatio = CGFloat(0.6)
        static let textFieldBorderWidth = CGFloat(0.7)
    }

    private weak var delegate: LoginViewControllerDelegate?

    private var viewModel: LoginViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
        self.bindViewModel()
    }

    func create(delegate: LoginViewControllerDelegate, viewModel: LoginViewModel) {
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
        button.layer.cornerRadius = CGFloat(15)
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
                UserSupervisor.shared.login(email: email, score: user.score, imageURLString: imageURLString)
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        self.view.frame.origin = CGPoint(x: 0, y: 0)
        self.modifyTextFieldBorder(index: 0)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.viewModel?.startEditing()
        self.designateSignupButtonState()
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailInputView.textField:
            self.modifyTextFieldBorder(index: 1)
        case self.passwordInputView.textField:
            self.modifyTextFieldBorder(index: 2)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.frame.origin = CGPoint(x: 0, y: -self.emailInputView.frame.height)
            })
        default:
            break
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case self.emailInputView.textField:
            self.passwordInputView.textField?.becomeFirstResponder()
        case self.passwordInputView.textField:
            textField.endEditing(true)
            UIView.animate(withDuration: 0.2, animations: {
                self.modifyTextFieldBorder(index: 0)
                self.view.frame.origin = CGPoint(x: 0, y: 0)
            })
        default:
            break
        }
        return true
    }

    func modifyTextFieldBorder(index: Int) {
        switch index {
        case 0:
            self.emailInputView.textField?.layer.borderWidth = 0
            self.passwordInputView.textField?.layer.borderWidth = 0
        case 1:
            self.emailInputView.textField?.layer.borderWidth = Constant.textFieldBorderWidth
            self.passwordInputView.textField?.layer.borderWidth = 0
        case 2:
            self.emailInputView.textField?.layer.borderWidth = 0
            self.passwordInputView.textField?.layer.borderWidth = Constant.textFieldBorderWidth
        default:
            break
        }
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
            self.pumpkinImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.pumpkinImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Constant.middleWidthRatio),
            self.pumpkinImageView.heightAnchor.constraint(equalTo: self.pumpkinImageView.widthAnchor, multiplier: 0.9)
        ])
    }

    func configureLoginLabelLayout() {
        self.loginLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginLabel)
        NSLayoutConstraint.activate([
            self.loginLabel.topAnchor.constraint(equalTo: self.pumpkinImageView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    func configureEmailInputViewLayout() {
        self.emailInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emailInputView)
        NSLayoutConstraint.activate([
            self.emailInputView.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor, constant: Constant.middleVerticalSpace),
            self.emailInputView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emailInputView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Constant.inputViewWidthRatio),
            self.emailInputView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Constant.inputViewHeightRatio)
        ])
    }

    func configurePasswordInputViewLayout() {
        self.passwordInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.passwordInputView)
        NSLayoutConstraint.activate([
            self.passwordInputView.topAnchor.constraint(equalTo: self.emailInputView.bottomAnchor),
            self.passwordInputView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.passwordInputView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Constant.inputViewWidthRatio),
            self.passwordInputView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: Constant.inputViewHeightRatio)
        ])
    }

    func configureLoginButtonLayout() {
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.loginButton)
        NSLayoutConstraint.activate([
            self.loginButton.topAnchor.constraint(equalTo: self.passwordInputView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: Constant.middleWidthRatio),
            self.loginButton.heightAnchor.constraint(equalToConstant: Constant.loginButtonHeight)
        ])
    }
}
