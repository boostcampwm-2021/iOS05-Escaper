//
//  EmptyResultView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/27.
//

import UIKit

class EmptyResultView: UIView {
    private let imageView: UIImageView = UIImageView(image: UIImage(named: Genre.fear.detailImageAssetName))
    private let contentLabel: UILabel = {
        let label = EDSLabel.b01B(text: "검색 결과가 없어요. 다른 지역을 선택해주세요.", color: .skullWhite)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
}

private extension EmptyResultView {
    func configure() {
        self.configureImageView()
        self.configureContentView()
    }

    func configureImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func configureContentView() {
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentLabel)
        NSLayoutConstraint.activate([
            self.contentLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10),
            self.contentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
