//
//  UserInputView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/16.
//

import UIKit

class UserInputView: UIView {
    var textField: UserInputTextField?
    var guideWordsLabel: UILabel = {
        let label = UILabel()
        label.textColor = EDSColor.bloodyBurgundy.value
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(viewType: TextFieldType) {
        self.init(frame: .zero)
        self.configure(viewType: viewType)
        self.configureLayout()
    }

    func injectDelegate(_ delegate: UITextFieldDelegate) {
        self.textField?.delegate = delegate
    }
}

private extension UserInputView {
    func configure(viewType: TextFieldType) {
        self.textField = UserInputTextField(viewType: viewType)
    }

    func configureLayout() {
        self.configureTextFieldLayout()
        self.configureGuideWordsLabelLayout()
    }

    func configureTextFieldLayout() {
        self.textField?.translatesAutoresizingMaskIntoConstraints = false
        if let textField = self.textField {
            self.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: self.topAnchor),
                textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6)
            ])
        }
    }

    func configureGuideWordsLabelLayout() {
        self.guideWordsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.guideWordsLabel)
        NSLayoutConstraint.activate([
            self.guideWordsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.guideWordsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.guideWordsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.guideWordsLabel.topAnchor.constraint(equalTo: self.textField!.bottomAnchor),
            self.guideWordsLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }
}
