//
//  SignUpViewController.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/17.
//

import UIKit

class SignUpViewController: DefaultViewController {
    enum Constant {
        static let shortHorizontalSpace = CGFloat(30)
        static let middleHorizontalSpace = CGFloat(60)
        static let longHorizontalSpace = CGFloat(110)
        static let shortVerticalSpace = CGFloat(20)
        static let middleVerticalSpace = CGFloat(60)
        static let longVerticalSpace = CGFloat(75)
        static let textFieldHeight = CGFloat(60)
        static let defaultSpace = CGFloat(15)
        static let signupButtonHeight = CGFloat(45)
    }

    private var viewModel: SignUpViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.create()
        self.configure()
        self.configureLayout()
        self.pumpkinImageButtonTapped()
        self.bindViewModel()
    }

    func create() {
        let userRepository = UserRepository(service: FirebaseService.shared)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = SignUpViewModel(usecase: userUsecase)
        self.viewModel = viewModel
    }

    func bindViewModel() {
        self.viewModel?.emailMessage.observe(on: self) { [weak self] text in
            self?.emailInputView.guideWordsLabel.text = text
        }
        self.viewModel?.passwordMessage.observe(on: self) { [weak self] text in
            self?.passwordInputView.guideWordsLabel.text = text
        }
        self.viewModel?.passwordCheckMessage.observe(on: self) { [weak self] text in
            self?.passwordCheckInputView.guideWordsLabel.text = text
        }
    }

    private let imagePickerController = UIImagePickerController()
    private lazy var selectedButton: UIButton = self.pumpkinImageButton
    private var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(EDSColor.bloodyBurgundy.value, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    private var signupLabel: UILabel = {
        let label = EDSLabel.h02B(text: "회원가입", color: EDSColor.skullLightWhite)
        label.textAlignment = .center
        return label
    }()
    private var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    private var pumpkinImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "loginPumpkin"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = EDSColor.pumpkin.value?.cgColor
        return button
    }()
    private var ghostImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "signupGhost"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = EDSColor.pumpkin.value?.cgColor
        return button
    }()
    private var skullImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "signupSkull"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = EDSColor.pumpkin.value?.cgColor
        return button
    }()
    private var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "signupPlus"), for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderColor = EDSColor.pumpkin.value?.cgColor
        return button
    }()
    private var emailInputView: UserInputView = UserInputView(viewType: .email)
    private var passwordInputView: UserInputView = UserInputView(viewType: .password)
    private var passwordCheckInputView: UserInputView = UserInputView(viewType: .passwordCheck)
    private var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(EDSColor.skullLightWhite.value, for: .normal)
        button.layer.cornerRadius = CGFloat(20)
        button.layer.masksToBounds = true
        button.backgroundColor = EDSColor.gloomyPurple.value
        button.isEnabled = false
        return button
    }()

    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func pumpkinImageButtonTapped() {
        self.selectedButton.layer.borderWidth = 0
        self.selectedButton = self.pumpkinImageButton
        self.imageView.image = EDSImage.loginPumpkin.value
        self.pumpkinImageButton.layer.borderWidth = 4
    }

    @objc func ghostImageButtonTapped() {
        self.selectedButton.layer.borderWidth = 0
        self.selectedButton = self.ghostImageButton
        self.imageView.image = EDSImage.signupGhost.value
        self.ghostImageButton.layer.borderWidth = 4
    }

    @objc func skullImageButtonTapped() {
        self.selectedButton.layer.borderWidth = 0
        self.selectedButton = self.skullImageButton
        self.imageView.image = EDSImage.signupSkull.value
        self.skullImageButton.layer.borderWidth = 4
    }

    @objc func addImageButtonTapped() {
        self.selectedButton.layer.borderWidth = 0
        self.selectedButton = self.addImageButton
        self.present(self.imagePickerController, animated: true, completion: nil)
        self.addImageButton.layer.borderWidth = 4
    }

    @objc func signupButtonTapped() {
        ImageCacheManager.shared.uploadUser(image: self.imageView.image, userEmail: (self.emailInputView.textField?.text)!) { result in
            switch result {
            case .success(let urlString):
                self.viewModel?.queryUser(email: (self.emailInputView.textField?.text)!) { isExist in
                    if isExist {
                        self.designateSignupButtonState()
                    } else {
                        self.viewModel?.addUser(email: (self.emailInputView.textField?.text)!, password: (self.passwordInputView.textField?.text)!, urlString: urlString)
                        self.dismiss(animated: true)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func designateSignupButtonState() {
        if self.viewModel!.isSignupButtonEnabled() {
            self.signupButton.backgroundColor = EDSColor.bloodyBurgundy.value
            self.signupButton.isEnabled = true
        } else {
            self.signupButton.backgroundColor = EDSColor.gloomyPurple.value
            self.signupButton.isEnabled = false
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var newImage: UIImage?
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = selectedImage
        } else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = selectedImage
        }
        self.imageView.image = newImage
        picker.dismiss(animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case self.emailInputView.textField:
            self.viewModel?.checkEmail(text: textField.text!)
        case self.passwordInputView.textField:
            self.viewModel?.checkPassword(text: textField.text!)
        case self.passwordCheckInputView.textField:
            self.viewModel?.checkDiscordance(text1: (self.passwordInputView.textField?.text)!, text2: textField.text!)
        default:
            print("what?")
        }
        self.designateSignupButtonState()
    }
}

extension SignUpViewController {
    func configure() {
        self.injectDelegate()
        self.configureImageStackView()
        self.configureAddTarget()
        self.configureImagePickerController()
    }

    func configureLayout() {
        self.configureCancelButtonLayout()
        self.configureImageViewLayout()
        self.configureSignupLabelLayout()
        self.configureImageStackViewLayout()
        self.configureImageStackViewElementLayout()
        self.configureEmailInputViewLayout()
        self.configurePasswordInputViewLayout()
        self.configurePasswordCheckInputViewLayout()
        self.configureSignupButtonLayout()
    }

    func injectDelegate() {
        self.emailInputView.injectDelegate(self)
        self.passwordInputView.injectDelegate(self)
        self.passwordCheckInputView.injectDelegate(self)
    }

    func configureImageStackView() {
        self.imageStackView.addArrangedSubview(self.pumpkinImageButton)
        self.imageStackView.addArrangedSubview(self.ghostImageButton)
        self.imageStackView.addArrangedSubview(self.skullImageButton)
        self.imageStackView.addArrangedSubview(self.addImageButton)
    }

    func configureAddTarget() {
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        self.pumpkinImageButton.addTarget(self, action: #selector(self.pumpkinImageButtonTapped), for: .touchUpInside)
        self.ghostImageButton.addTarget(self, action: #selector(self.ghostImageButtonTapped), for: .touchUpInside)
        self.skullImageButton.addTarget(self, action: #selector(self.skullImageButtonTapped), for: .touchUpInside)
        self.addImageButton.addTarget(self, action: #selector(self.addImageButtonTapped), for: .touchUpInside)
        self.signupButton.addTarget(self, action: #selector(self.signupButtonTapped), for: .touchUpInside)
    }

    func configureImagePickerController() {
        self.imagePickerController.sourceType = .photoLibrary
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.delegate = self
    }

    func configureCancelButtonLayout() {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.cancelButton)
        NSLayoutConstraint.activate([
            self.cancelButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constant.defaultSpace),
            self.cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.defaultSpace)
        ])
    }

    func configureImageViewLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: Constant.middleVerticalSpace),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor)
        ])
    }

    func configureSignupLabelLayout() {
        self.signupLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.signupLabel)
        NSLayoutConstraint.activate([
            self.signupLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.signupLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.signupLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace)
        ])
    }

    func configureImageStackViewLayout() {
        self.imageStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageStackView)
        NSLayoutConstraint.activate([
            self.imageStackView.topAnchor.constraint(equalTo: self.signupLabel.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.middleHorizontalSpace),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.middleHorizontalSpace),
            self.imageStackView.heightAnchor.constraint(equalToConstant: Constant.textFieldHeight)
        ])
    }

    func configureImageStackViewElementLayout() {
        self.pumpkinImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.ghostImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.skullImageButton.translatesAutoresizingMaskIntoConstraints = false
        self.addImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pumpkinImageButton.widthAnchor.constraint(equalTo: self.pumpkinImageButton.heightAnchor),
            self.ghostImageButton.widthAnchor.constraint(equalTo: self.ghostImageButton.heightAnchor),
            self.skullImageButton.widthAnchor.constraint(equalTo: self.skullImageButton.heightAnchor),
            self.addImageButton.widthAnchor.constraint(equalTo: self.addImageButton.heightAnchor)
        ])
    }

    func configureEmailInputViewLayout() {
        self.emailInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emailInputView)
        NSLayoutConstraint.activate([
            self.emailInputView.topAnchor.constraint(equalTo: self.imageStackView.bottomAnchor, constant: Constant.longVerticalSpace),
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

    func configurePasswordCheckInputViewLayout() {
        self.passwordCheckInputView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.passwordCheckInputView)
        NSLayoutConstraint.activate([
            self.passwordCheckInputView.topAnchor.constraint(equalTo: self.passwordInputView.bottomAnchor, constant: Constant.shortVerticalSpace),
            self.passwordCheckInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.shortHorizontalSpace),
            self.passwordCheckInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.shortHorizontalSpace),
            self.passwordCheckInputView.heightAnchor.constraint(equalToConstant: Constant.textFieldHeight)
        ])
    }

    func configureSignupButtonLayout() {
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.signupButton)
        NSLayoutConstraint.activate([
            self.signupButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Constant.longVerticalSpace),
            self.signupButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.signupButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace),
            self.signupButton.heightAnchor.constraint(equalToConstant: Constant.signupButtonHeight)
        ])
    }
}
