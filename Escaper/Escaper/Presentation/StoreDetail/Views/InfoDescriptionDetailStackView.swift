//
//  InfoDescriptionDetailStackView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

class InfoDescriptionDetailStackView: UIStackView {
    private var infoTitleLabel: UILabel = EDSLabel.b01B(color: .gloomyPink)
    private var infoContentLabel: UILabel = {
        let label = EDSLabel.b01B(color: .skullWhite)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init(title: String, content: String, shouldOpen: Bool = false) {
        self.init(frame: .zero)
        self.inject(title: title, content: content)
        if shouldOpen {
            let gestureRecognizer = UITapGestureRecognizer()
            gestureRecognizer.delegate = self
            self.infoContentLabel.addGestureRecognizer(gestureRecognizer)
            self.infoContentLabel.textColor = UIColor.systemBlue
            self.infoContentLabel.isUserInteractionEnabled = true
        }
    }
}

extension InfoDescriptionDetailStackView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let text = self.infoContentLabel.text else { return true }
        if Validator.checkUrlFormat(text: text) {
            guard let url = URL(string: text) else { return true }
            UIApplication.shared.open(url, options: [:])
            return true
        }
        if Validator.checkTelephoneFormat(text: text) {
            var urlComponents = URLComponents(string: text)
            urlComponents?.scheme = "tel"
            guard let url = urlComponents?.url else { return true }
            UIApplication.shared.open(url, options: [:])
        }
        return true
    }
}

private extension InfoDescriptionDetailStackView {
    enum Constant {
        static let infoTitleWidth = CGFloat(70)
    }

    func inject(title: String, content: String) {
        self.infoTitleLabel.text = title
        self.infoContentLabel.text = content
    }

    func configure() {
        self.configureStackView()
        self.configureTitleLabelLayout()
        self.addArrangedSubview(self.infoTitleLabel)
        self.addArrangedSubview(self.infoContentLabel)
    }

    func configureStackView() {
        self.alignment = .fill
        self.distribution = .fill
        self.axis = .horizontal
        self.isUserInteractionEnabled = true
    }

    func configureTitleLabelLayout() {
        self.infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoTitleLabel.widthAnchor.constraint(equalToConstant: Constant.infoTitleWidth).isActive = true
    }
}
