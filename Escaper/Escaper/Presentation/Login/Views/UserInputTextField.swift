//
//  UserInputTextField.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/17.
//

import UIKit

class UserInputTextField: UITextField {
    private var imageView: UIImageView = UIImageView()
    private var eyeButton: UIButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(viewType: TextFieldType) {
        self.init(frame: .zero)
        self.configureTextField(viewType: viewType)
    }

    @objc func eyeButtonTouched() {
        self.isSecureTextEntry = self.isSecureTextEntry ? false : true
    }
}

extension UserInputTextField {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.leftViewRect(forBounds: bounds)
        padding.origin.x += 15
        return padding
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var padding = super.rightViewRect(forBounds: bounds)
        padding.origin.x -= 15
        return padding
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 10))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 10))
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 10, left: 50, bottom: 10, right: 10))
    }
}

extension UserInputTextField {
    func configureTextField(viewType: TextFieldType) {
        self.configureAddTarget()
        self.configureTextFieldAttribute(viewType: viewType)
        self.configureImageView(viewType: viewType)
        self.configureEyeButton(viewType: viewType)
        self.configureTextFieldComponent()
        self.layer.borderColor = EDSColor.skullWhite.value?.cgColor
    }

    func configureAddTarget() {
        self.eyeButton.addTarget(self, action: #selector(self.eyeButtonTouched), for: .touchUpInside)
    }

    func configureTextFieldAttribute(viewType: TextFieldType) {
        self.textColor = EDSColor.skullLightWhite.value
        self.backgroundColor = EDSColor.gloomyBrown.value
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.layer.cornerRadius = 10
        self.textContentType = .oneTimeCode
        switch viewType {
        case .email:
            self.isSecureTextEntry = false
        default:
            self.isSecureTextEntry = true
        }
    }

    func configureImageView(viewType: TextFieldType) {
        switch viewType {
        case .email:
            self.imageView.image = EDSImage.emailIcon.value
            self.attributedPlaceholder = NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor: EDSColor.skullLightWhite.value as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        case .password:
            self.imageView.image = EDSImage.passwordIcon.value
            self.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: EDSColor.skullLightWhite.value as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        case .passwordCheck:
            self.imageView.image = EDSImage.passwordIcon.value
            self.attributedPlaceholder = NSAttributedString(string: "비밀번호 확인", attributes: [NSAttributedString.Key.foregroundColor: EDSColor.skullLightWhite.value as Any, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        }
    }

    func configureEyeButton(viewType: TextFieldType) {
        switch viewType {
        case .email:
            self.eyeButton.isHidden = true
        default:
            self.eyeButton.setImage(EDSImage.eyeIcon.value, for: .normal)
        }
    }

    func configureTextFieldComponent() {
        self.leftView = self.imageView
        self.leftViewMode = UITextField.ViewMode.always
        self.rightView = self.eyeButton
        self.rightViewMode = UITextField.ViewMode.always
    }
}
