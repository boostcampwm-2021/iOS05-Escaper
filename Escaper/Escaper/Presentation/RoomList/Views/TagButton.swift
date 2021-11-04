//
//  TagButton.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/03.
//

import UIKit

final class TagButton: UIButton {
    private(set) var element: Tagable?

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
        self.setTitle(element.name, for: .normal)
    }
    
    func touched() {
        self.backgroundColor = UIColor(named: ColorPalette.pumpkin.code)
    }

    func untouched() {
        self.backgroundColor = UIColor(named: ColorPalette.bloodyDarkBurgundy.code)
    }
}

private extension TagButton {
    func configure() {
        self.layer.cornerRadius = 5
        self.titleLabel?.textColor = UIColor(named: ColorPalette.skullWhite.code)
        self.untouched()
    }
}
