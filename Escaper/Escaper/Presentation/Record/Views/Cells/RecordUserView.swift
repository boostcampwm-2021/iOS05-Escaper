//
//  RecordUserView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

final class RecordUserView: UIView {
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = CGFloat(20)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let participantLabel: UILabel = EDSLabel.b02R(text: "참가자", color: .gloomyPurple)
    private let nicknameLabel: UILabel = EDSLabel.b01B(text: "", color: .bloodyBlack)
    private let resultLabel: UILabel = {
        let label = EDSLabel.b03R(color: .bloodyBlack)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = EDSColor.gloomyBrown.value
        return label
    }()
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.userImageView.layer.cornerRadius = self.userImageView.bounds.width/2
        self.resultLabel.layer.cornerRadius = self.resultLabel.bounds.height / 2
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
        ImageCacheManager.shared.download(urlString: UserSupervisor.shared.imageURLString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func prepareForReuse() {
        self.nicknameLabel.text = ""
        self.resultLabel.text = ""
        self.userImageView.image = nil
    }
}

private extension RecordUserView {
    enum Constant {
        static let verticalSpace = CGFloat(10)
        static let horizontalSpace = CGFloat(5)
    }

    enum Result: String {
        case success = "Success"
        case fail = "Fail"

        var name: String {
            return self.rawValue
        }
    }

    func configureLayout() {
        self.configureArrangedSubViews()
        self.configureStackViewLayout()
        self.configureUserImageViewLayout()
        self.configureResultLabelLayout()
        self.configureVerticalStackViewLayout()
    }

    func configureArrangedSubViews() {
        self.horizontalStackView.addArrangedSubview(self.nicknameLabel)
        self.horizontalStackView.addArrangedSubview(self.resultLabel)
        self.verticalStackView.addArrangedSubview(self.participantLabel)
        self.verticalStackView.addArrangedSubview(self.horizontalStackView)
        self.stackView.addArrangedSubview(self.userImageView)
        self.stackView.addArrangedSubview(self.verticalStackView)
    }

    func configureStackViewLayout() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stackView)

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func configureUserImageViewLayout() {
        self.userImageView.widthAnchor.constraint(equalTo: self.userImageView.heightAnchor).isActive = true
    }

    func configureResultLabelLayout() {
        self.resultLabel.widthAnchor.constraint(equalTo: self.verticalStackView.widthAnchor, multiplier: 0.35).isActive = true
        self.resultLabel.heightAnchor.constraint(equalTo: self.resultLabel.widthAnchor, multiplier: 0.4).isActive = true
    }

    func configureVerticalStackViewLayout() {
        self.verticalStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        self.verticalStackView.isLayoutMarginsRelativeArrangement = true
    }
}
