//
//  UserLoginedView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/25.
//

import UIKit

protocol UserLoginedViewDelegate: AnyObject {
    func logoutButtonTouched() // userSupervisor 설정
}

final class UserLoginedView: UserSettingView {
    weak var delegate: UserLoginedViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func update() {
        ImageCacheManager.shared.download(urlString: UserSupervisor.shared.imageURLString) { result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                guard let username = Helper.parseUsername(email: UserSupervisor.shared.email) else { return }
                DispatchQueue.main.async {
                    super.inject(image: image, title: username)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

private extension UserLoginedView {
    func configure() {
        super.changeButtonAppearance(appearance: .logout)
        self.configureButtonTarget()
    }

    func configureButtonTarget() {
        self.registerButton.addTarget(self, action: #selector(self.logoutButtonTouched(sender:)), for: .touchUpInside)
    }

    @objc func logoutButtonTouched(sender: UIButton) {
        self.delegate?.logoutButtonTouched()
    }
}
