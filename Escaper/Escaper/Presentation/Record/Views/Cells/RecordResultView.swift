//
//  RecordResultView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/10.
//

import UIKit

final class RecordResultView: UIView {
    private let rankLabel: UILabel = EDSLabel.b01B(text: "Rank", color: .gloomyPurple)
    private var rankResultLabel = EDSLabel.h02B(color: .bloodyBlack)
    private let timeLabel: UILabel = EDSLabel.b01B(text: "Time", color: .gloomyPurple)
    private var timeResultLabel =  EDSLabel.h02B(color: .bloodyBlack)
    private let rankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
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
        self.rankResultLabel.text = String(format: "%02d", playerRank) + "/" + String(format: "%02d", numberOfPlayers)
        self.timeResultLabel.text = String(format: "%02d", time/60) + ":" + String(format: "%02d", time%60)
    }

    func prepareForReuse() {
        self.rankResultLabel.text = ""
        self.timeResultLabel.text = ""
    }
}

private extension RecordResultView {
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
