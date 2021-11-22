//
//  StoreInformationStackView.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/21.
//

import UIKit

class StoreInformationStackView: UIStackView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = EDSLabel.b02R(color: .skullLightWhite)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func setTitle(_ text: String) {
        self.titleLabel.text = text
    }

    func setImage(_ image: UIImage?) {
        self.imageView.image = image
    }

    func setColor(_ color: UIColor?) {
        self.imageView.tintColor = color
        self.titleLabel.textColor = color
    }
}

private extension StoreInformationStackView {
    func configure() {
        self.addArrangedSubview(self.imageView)
        self.addArrangedSubview(self.titleLabel)
        self.configureStackView()
        self.configureImageViewLayout()
    }

    func configureStackView() {
        self.axis = .horizontal
        self.distribution = .fill
        self.spacing = 5
    }

    func configureImageViewLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 14),
            self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor)
        ])
    }
}
