//
//  SettingViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/25.
//

import UIKit

final class SettingViewController: DefaultViewController {
    private var viewModel: SettingViewModelInterface?
    private let titleLabel: UILabel = {
        let label: UILabel = EDSLabel.h01B(text: "설정", color: .skullWhite)
        label.textAlignment = .center
        return label
    }()
    private let elementStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private let userLoginedView = UserLoginedView()
    private let userLogoutedView = UserLogoutedView()
    private let feedBackView = FeedBackView()
    private let developerLabel = EDSLabel.h01B(text: "Developers", color: .pumpkin)
    private let infoDescriptionStackView = InfoDescriptionStackView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUserView()
    }

    func create(viewModel: SettingViewModelInterface) {
        self.viewModel = viewModel
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension SettingViewController: LoginViewControllerDelegate {
    func loginSuccessed() {
        self.updateUserView()
    }
}

extension SettingViewController: UserLoginedViewDelegate {
    func logoutButtonTouched() {
        UserSupervisor.shared.logout()
        self.updateUserView()
    }
}

extension SettingViewController: UserLogoutedViewDelegate {
    func loginButtonTouched() {
        let viewController = LoginViewController()
        let userRepository = UserRepository(service: FirebaseService.shared)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = DefaultLoginViewModel(usecase: userUsecase)
        viewController.create(delegate: self, viewModel: viewModel)
        self.present(viewController, animated: true)
    }
}

extension SettingViewController: FeedBackViewDelegate {
    func feedBackSendButtonTouched(text: String) {
        self.viewModel?.addFeedback(content: text)
    }
}

private extension SettingViewController {
    enum Constant {
        static let widthPortion = CGFloat(0.9)
        static let topVerticalSpace = CGFloat(20)
        static let topTinyVerticalSpace = CGFloat(5)
        static let sideSpace = CGFloat(20)
    }

    func configure() {
        self.configureDelegates()
        self.configureTitleLabelLayout()
        self.configureResisterViewLayout()
        self.configureFeedBackViewLayout()
        self.configureElementStackViewLayout()
        self.configureInfoDescriptionStackViewLayout()
        self.configureDeveloperLabelLayout()
        self.updateUserView()
        self.configureElementStackView()
        self.configureDeveloperInfoDesctiptionStackView()
    }

    func configureDelegates() {
        self.userLogoutedView.delegate = self
        self.userLoginedView.delegate = self
        self.feedBackView.delegate = self
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.topVerticalSpace),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.sideSpace),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.sideSpace)
        ])
    }

    func configureResisterViewLayout() {
        self.userLoginedView.translatesAutoresizingMaskIntoConstraints = false
        self.userLogoutedView.translatesAutoresizingMaskIntoConstraints = false
        self.userLoginedView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.userLogoutedView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }

    func configureFeedBackViewLayout() {
        self.feedBackView.translatesAutoresizingMaskIntoConstraints = false
        self.feedBackView.heightAnchor.constraint(equalToConstant: 240).isActive = true
    }

    func configureElementStackViewLayout() {
        self.elementStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.elementStackView)
        NSLayoutConstraint.activate([
            self.elementStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.topVerticalSpace),
            self.elementStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.elementStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: Constant.widthPortion)
        ])
    }

    func configureInfoDescriptionStackViewLayout() {
        self.infoDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.infoDescriptionStackView)
        NSLayoutConstraint.activate([
            self.infoDescriptionStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Constant.topVerticalSpace),
            self.infoDescriptionStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.infoDescriptionStackView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: Constant.widthPortion)
        ])
    }

    func configureDeveloperLabelLayout() {
        self.developerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.developerLabel)
        NSLayoutConstraint.activate([
            self.developerLabel.bottomAnchor.constraint(equalTo: self.infoDescriptionStackView.topAnchor, constant: -Constant.topTinyVerticalSpace),
            self.developerLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.developerLabel.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: Constant.widthPortion)
        ])
    }

    func updateUserView() {
        if UserSupervisor.shared.isLogined {
            self.userLoginedView.update()
            self.userLogoutedView.removeFromSuperview()
            self.elementStackView.insertArrangedSubview(self.userLoginedView, at: .zero)
        } else {
            self.userLoginedView.removeFromSuperview()
            self.elementStackView.insertArrangedSubview(self.userLogoutedView, at: .zero)
        }
    }

    func configureElementStackView() {
        self.elementStackView.addArrangedSubview(self.feedBackView)
    }

    func configureDeveloperInfoDesctiptionStackView() {
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "최완식", content: "https://github.com/wansook0316", shouldOpen: true))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "노신희", content: "https://github.com/shinhee-rebecca", shouldOpen: true))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "정택현", content: "https://github.com/jeffoio", shouldOpen: true))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "박영광", content: "https://github.com/poisonF2", shouldOpen: true))
    }
}

