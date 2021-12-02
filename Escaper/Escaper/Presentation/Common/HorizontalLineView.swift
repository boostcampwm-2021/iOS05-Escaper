//
//  HorizontalLineView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit

final class HorizontalLineView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    convenience init(color: UIColor?) {
        self.init(frame: .zero)
        self.backgroundColor = color
    }
}

private extension HorizontalLineView {
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
