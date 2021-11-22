//
//  InfoDescriptionDetailStackView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

class InfoDescriptionDetailStackView: UIStackView {
    private var infoTitleLabel: UILabel = {
        let label = EDSLabel.b01B(color: .gloomyPink)
        return label
    }()
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

    convenience init(title: String, content: String) {
        self.init(frame: .zero)
        self.inject(title: title, content: content)
    }

    func inject(title: String, content: String) {
        self.infoTitleLabel.text = title
        self.infoContentLabel.text = content
    }
}

private extension InfoDescriptionDetailStackView {
    enum Constant {
        static let infoTitleWidth = CGFloat(70)
    }
    func configure() {
        self.configureStackView()
        self.configureTitleLabelLayout()
        self.configureContentLabelLayout()
        self.addArrangedSubview(self.infoTitleLabel)
        self.addArrangedSubview(self.infoContentLabel)
    }

    func configureStackView() {
        self.alignment = .fill
        self.distribution = .fill
        self.axis = .horizontal
    }

    func configureTitleLabelLayout() {
        self.infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.infoTitleLabel.widthAnchor.constraint(equalToConstant: Constant.infoTitleWidth)
        ])
    }

    func configureContentLabelLayout() {
        self.infoContentLabel.translatesAutoresizingMaskIntoConstraints = false
    }
}
