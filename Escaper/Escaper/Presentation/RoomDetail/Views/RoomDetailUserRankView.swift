//
//  RoomDetailUserRankView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/10.
//

import UIKit

class RoomDetailUserRankView: UIView {
    static let rankColor = [EDSColor.pumpkin.value, EDSColor.gloomyPink.value, EDSColor.gloomyRed.value]

    private enum Constant {
        static let userImageSize: CGFloat = 50
        static let sideSpace: CGFloat = 32
        static let gapSpace: CGFloat = 10
        static let rankSize: CGFloat = 8
        static let titleLabelSize: CGFloat = 100
    }

    private let rankLabel: UILabel = {
        let label = EDSLabel.b01B(color: .bloodyBlack)
        label.textAlignment = .left
        return label
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let titleLabel = EDSLabel.b01B(color: .bloodyBlack)
    private let timeLabel = EDSLabel.b01R(color: .bloodyBlack)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    func update(_ user: UserRecord, rank: Int) {
        self.rankLabel.text = "\(rank + 1)"
        self.imageView.image = UIImage(named: "romancePreview")
        self.titleLabel.text = user.nickname
        self.timeLabel.text = self.timeToString(time: user.playTime)
        self.backgroundColor = .clear
        self.backgroundColor = Self.rankColor[rank]
    }
}

private extension RoomDetailUserRankView {
    func configureLayout() {
        self.userRankLabelLayout()
        self.userImageViewLayout()
        self.userTitleLabelLayout()
        self.userTimeLabelLayout()
    }

    func userRankLabelLayout() {
        self.rankLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.rankLabel)
        NSLayoutConstraint.activate([
            self.rankLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.rankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace),
            self.rankLabel.widthAnchor.constraint(equalToConstant: Constant.rankSize)
        ])
    }

    func userImageViewLayout() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.centerYAnchor.constraint(equalTo: self.rankLabel.centerYAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.rankLabel.trailingAnchor, constant: Constant.gapSpace),
            self.imageView.widthAnchor.constraint(equalToConstant: Constant.userImageSize),
            self.imageView.heightAnchor.constraint(equalToConstant: Constant.userImageSize)
        ])
        self.imageView.layer.cornerRadius = Constant.userImageSize/2
    }

    func userTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: Constant.gapSpace),
            self.titleLabel.widthAnchor.constraint(equalToConstant: Constant.titleLabelSize)
        ])
    }

    func userTimeLabelLayout() {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeLabel)
        NSLayoutConstraint.activate([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.sideSpace)
        ])
    }

    func timeToString(time: Int) -> String {
        var ret = ""
        var time = time
        let second = time % 60
        if second > 0 {
            ret = "\(second)s " + ret
        }
        time /= 60
        let min = time % 60
        if min > 0 {
            ret = "\(min)m " + ret
        }
        time /= 60
        let hour = time % 60
        if hour > 0 {
            ret = "\(hour)h " + ret
        }
        return ret
    }
}
