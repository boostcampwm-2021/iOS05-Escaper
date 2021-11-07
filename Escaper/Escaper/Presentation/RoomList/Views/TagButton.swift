//
//  TagButton.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/03.
//

import UIKit

final class TagButton: UIButton {
    enum Constant {
        static let cornerRadius = CGFloat(7)
    }

    private(set) var element: Tagable?
    private var elementLabel: UILabel = {
        let label = EDSKit.Label.b01R(color: .skullWhite)
        label.textAlignment = .center
        return label
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init(element: Tagable) {
        self.init(frame: .zero)
        self.element = element
        self.elementLabel.text = element.name
    }

    func touched() {
        self.backgroundColor = EDSColor.pumpkin.value
    }

    func untouched() {
        self.backgroundColor = EDSColor.bloodyDarkBurgundy.value
    }
}

private extension TagButton {
    func configure() {
        self.configureButtonUI()
        self.configureElementLabelLayout()
    }

    func configureButtonUI() {
        self.layer.cornerRadius = Constant.cornerRadius
        self.untouched()
    }

    func configureElementLabelLayout() {
        self.elementLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(elementLabel)
        NSLayoutConstraint.activate([
            self.elementLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.elementLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
