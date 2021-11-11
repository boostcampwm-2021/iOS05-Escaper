//
//  RecordHeadView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

class RecordHeadView: UIView {
    enum Constant {
        static let defaultVerticalSpace = CGFloat(10)
    }

    private var recordImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = CGFloat(15)
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private var titleLabel: UILabel = {
        let label = EDSLabel.h02B(text: "미스테리 거울의 방", color: .bloodyBlack)
        label.textAlignment = .center
        return label
    }()
    private var placeLabel: UILabel = {
        let label = EDSLabel.b01R(text: "이스케이프룸 강남점", color: .gloomyPurple)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    func update(imageURLString: String, title: String, place: String) {
        self.titleLabel.text = title
        self.placeLabel.text = place
        ImageCacheManager.shared.download(urlString: imageURLString) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    self?.recordImageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension RecordHeadView {
    func configureLayout() {
        configureRecordImageViewLayout()
        configureTitleLabelLayout()
        configurePlaceLabelLayout()
    }

    func configureRecordImageViewLayout() {
        self.recordImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordImageView)
        NSLayoutConstraint.activate([
            self.recordImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.recordImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            self.recordImageView.widthAnchor.constraint(equalTo: self.recordImageView.heightAnchor),
            self.recordImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.recordImageView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    func configurePlaceLabelLayout() {
        self.placeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.placeLabel)
        NSLayoutConstraint.activate([
            self.placeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.placeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
