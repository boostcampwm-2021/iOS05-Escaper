//
//  InfoDescriptionStackView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

class InfoDescriptionStackView: UIStackView {
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    func inject(view: UIView) {
        let endIndex = self.arrangedSubviews.count-1
        self.insertArrangedSubview(view, at: endIndex)
    }
}

private extension InfoDescriptionStackView {
    enum Constant {
        static let verticalSpace = CGFloat(10)
    }

    func configure() {
        self.configureStackView()
    }

    func configureStackView() {
        self.distribution = .fill
        self.alignment = .fill
        self.axis = .vertical
        self.spacing = Constant.verticalSpace
        self.addArrangedSubview(HorizontalLineView(color: EDSColor.gloomyPurple.value))
        self.addArrangedSubview(HorizontalLineView(color: EDSColor.gloomyPurple.value))
        self.isUserInteractionEnabled = true
    }
}
