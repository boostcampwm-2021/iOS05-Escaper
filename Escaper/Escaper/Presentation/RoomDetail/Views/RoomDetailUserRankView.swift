//
//  RoomDetailUserRankView.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/10.
//

import UIKit

class RoomDetailUserRankView: UIView {
    private enum Constant {
        static let userImageSize: CGFloat = 50
        static let sideSpace: CGFloat = 32
        static let gapSpace: CGFloat = 10
        static let rankSize: CGFloat = 8
        static let titleLabelSize: CGFloat = 100
    }

    private let userRankLabel = EDSLabel.b01B(color: .bloodyBlack)
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let userTitleLabel = EDSLabel.b01B(color: .bloodyBlack)
    private let userTimeLabel = EDSLabel.b01R(color: .bloodyBlack)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    func update(_ user: UserRecord, rank: Int) {
        self.userRankLabel.text = "\(rank + 1)"
        self.userImageView.image = UIImage(named: "romancePreview")
        self.userTitleLabel.text = user.nickname
        self.userTimeLabel.text = self.timeToString(time: user.playTime)
        self.backgroundColor = .clear
        self.backgroundColor = [EDSColor.pumpkin.value, EDSColor.gloomyPink.value, EDSColor.gloomyRed.value][rank]
    }
}

private extension RoomDetailUserRankView {
    func configure() {
        self.userRankLabelLayout()
        self.userImageViewLayout()
        self.userTitleLabelLayout()
        self.userTimeLabelLayout()
    }

    func userRankLabelLayout() {
        self.userRankLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userRankLabel)
        NSLayoutConstraint.activate([
            self.userRankLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.userRankLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace),
            self.userRankLabel.widthAnchor.constraint(equalToConstant: Constant.rankSize)
        ])
    }

    func userImageViewLayout() {
        self.userImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userImageView)
        NSLayoutConstraint.activate([
            self.userImageView.centerYAnchor.constraint(equalTo: self.userRankLabel.centerYAnchor),
            self.userImageView.leadingAnchor.constraint(equalTo: self.userRankLabel.trailingAnchor, constant: Constant.gapSpace),
            self.userImageView.widthAnchor.constraint(equalToConstant: Constant.userImageSize),
            self.userImageView.heightAnchor.constraint(equalToConstant: Constant.userImageSize)
        ])
        self.userImageView.layer.cornerRadius = Constant.userImageSize/2
    }

    func userTitleLabelLayout() {
        self.userTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userTitleLabel)
        NSLayoutConstraint.activate([
            self.userTitleLabel.centerYAnchor.constraint(equalTo: self.userImageView.centerYAnchor),
            self.userTitleLabel.leadingAnchor.constraint(equalTo: self.userImageView.trailingAnchor, constant: Constant.gapSpace),
            self.userTitleLabel.widthAnchor.constraint(equalToConstant: Constant.titleLabelSize)
        ])

    }

    func userTimeLabelLayout() {
        self.userTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userTimeLabel)
        NSLayoutConstraint.activate([
            self.userTimeLabel.centerYAnchor.constraint(equalTo: self.userTitleLabel.centerYAnchor),
            self.userTimeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.sideSpace)
        ])
    }
}

private extension RoomDetailUserRankView {
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
