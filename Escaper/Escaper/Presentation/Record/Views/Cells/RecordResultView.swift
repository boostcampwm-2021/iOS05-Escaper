//
//  RecordResultView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

class RecordResultView: UIView {
    private let rankLabel: UILabel = {
        let label = EDSLabel.h03B(text: "Rank", color: .gloomyPurple)
        label.textAlignment = .center
        return label
    }()
    private var rankResultLabel: UILabel = {
        let label = UILabel()
        label.text = "12/33"
        label.textColor = EDSColor.bloodyBlack.value
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let timeLabel: UILabel = {
        let label = EDSLabel.h03B(text: "Time", color: .gloomyPurple)
        label.textAlignment = .center
        return label
    }()
    private var timeResultLabel: UILabel = {
        let label = UILabel()
        label.text = "27:40"
        label.textColor = EDSColor.bloodyBlack.value
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    func update(playerRank: Int, numberOfPlayers: Int, time: Int) {
        self.rankResultLabel.text = String(playerRank) + "/" + String(numberOfPlayers)
        self.timeResultLabel.text = String(time/60) + ":" + String(time%60)
    }
}

extension RecordResultView {
    func configureLayout() {
        configureRankStackViewLayout()
        configureTimeStackViewLayout()
    }

    func configureRankStackViewLayout() {
        self.rankStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.rankStackView)
        NSLayoutConstraint.activate([
            self.rankStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.rankStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.rankStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.rankStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
        self.rankStackView.addArrangedSubview(self.rankLabel)
        self.rankStackView.addArrangedSubview(self.rankResultLabel)
        NSLayoutConstraint.activate([
            self.rankLabel.heightAnchor.constraint(equalTo: self.rankStackView.heightAnchor, multiplier: 0.3),
            self.rankResultLabel.heightAnchor.constraint(equalTo: self.rankStackView.heightAnchor, multiplier: 0.7)
        ])
    }

    func configureTimeStackViewLayout() {
        self.timeStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.timeStackView)
        NSLayoutConstraint.activate([
            self.timeStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.timeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.timeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.timeStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5)
        ])
        self.timeStackView.addArrangedSubview(self.timeLabel)
        self.timeStackView.addArrangedSubview(self.timeResultLabel)
        NSLayoutConstraint.activate([
            self.timeLabel.heightAnchor.constraint(equalTo: self.timeStackView.heightAnchor, multiplier: 0.3),
            self.timeResultLabel.heightAnchor.constraint(equalTo: self.timeStackView.heightAnchor, multiplier: 0.7)
        ])
    }
}
