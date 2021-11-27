//
//  UserLogoutedView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/25.
//

import UIKit

protocol UserLogoutedViewDelegate: AnyObject {
    func loginButtonTouched() // userSupervior 설정
}

final class UserLogoutedView: UserSettingView {
    weak var delegate: UserLogoutedViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
}

private extension UserLogoutedView {
    func configure() {
        super.changeButtonAppearance(appearance: .login)
        self.configureButtonTarget()
        self.configureGuidingContents()
    }

    func configureGuidingContents() {
        let image = UIImage(named: Genre.sensitivity.previewImageAssetName)
        self.inject(image: image, title: "떠날 준비가 되었나요?")
    }

    func configureButtonTarget() {
        self.registerButton.addTarget(self, action: #selector(self.loginButtonTouched(sender:)), for: .touchUpInside)
    }

    @objc func loginButtonTouched(sender: UIButton) {
        self.delegate?.loginButtonTouched()
    }
}
