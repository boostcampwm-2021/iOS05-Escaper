//
//  FeedBackView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/25.
//

import UIKit

protocol FeedBackViewDelegate: AnyObject {
    func feedBackSendButtonTouched(text: String)
}

final class FeedBackView: UIView {
    weak var delegate: FeedBackViewDelegate?

    private let guideLabel: UILabel = EDSLabel.b01L(text: "간단한 피드백을 남겨주세요!", color: .skullWhite)
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = EDSColor.gloomyPurple.value
        textView.layer.masksToBounds = true
        textView.layer.borderColor = EDSColor.gloomyPurple.value?.cgColor
        textView.layer.cornerRadius = Constant.cornerRadius
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        return textView
    }()
    private let sendButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = EDSColor.pumpkin.value
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitle("보내기", for: .normal)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constant.cornerRadius
        return button
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

extension FeedBackView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Constant.placeholderColor {
            textView.text = nil
            textView.textColor = Constant.defaultColor
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.placeholderSetting()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

private extension FeedBackView {
    enum Constant {
        static let cornerRadius = CGFloat(10)
        static let sideSpace = CGFloat(10)
        static let verticalSpace = CGFloat(20)
        static let buttonHeightRatio = CGFloat(0.15)
        static let placeholderColor = EDSColor.gloomyPink.value
        static let defaultColor = EDSColor.skullWhite.value
    }

    func configure() {
        self.configureDelegates()
        self.configureAppearance()
        self.configureGuideLabelLayout()
        self.configureSendButtonLayout()
        self.configureTextViewLayout()
        self.configureSendButtonTarget()
        self.placeholderSetting()
    }

    func configureAppearance() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constant.cornerRadius
        self.backgroundColor = EDSColor.gloomyBrown.value
    }

    func configureGuideLabelLayout() {
        self.guideLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.guideLabel)
        NSLayoutConstraint.activate([
            self.guideLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.verticalSpace),
            self.guideLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace),
            self.guideLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.sideSpace)
        ])
    }

    func configureSendButtonLayout() {
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.sendButton)
        NSLayoutConstraint.activate([
            self.sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constant.verticalSpace),
            self.sendButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.sendButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            self.sendButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: Constant.buttonHeightRatio)
        ])
    }

    func configureTextViewLayout() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.guideLabel.bottomAnchor, constant: Constant.sideSpace),
            self.textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.sideSpace),
            self.textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constant.sideSpace),
            self.textView.bottomAnchor.constraint(equalTo: self.sendButton.topAnchor, constant: -15)
        ])
    }

    func configureDelegates() {
        self.textView.delegate = self
    }

    func configureSendButtonTarget() {
        self.sendButton.addTarget(self, action: #selector(self.sendButtonTouched(sender:)), for: .touchUpInside)
    }

    func placeholderSetting() {
        self.textView.text = "의견을 반영하여 좋은 서비스를 만드는데 기여하겠습니다!"
        self.textView.textColor = Constant.placeholderColor
    }

    @objc func sendButtonTouched(sender: UIButton) {
        guard let text = self.textView.text else { return }
        self.textView.resignFirstResponder()
        self.textView.text = "피드백이 반영되었습니다! 감사합니다."
        self.textView.textColor = Constant.placeholderColor
        self.delegate?.feedBackSendButtonTouched(text: text)
    }
}
