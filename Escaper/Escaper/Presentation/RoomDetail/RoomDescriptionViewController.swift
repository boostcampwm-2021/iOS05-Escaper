//
//  RoomDescriptionViewController.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/30.
//

import UIKit

class RoomDescriptionViewController: UIViewController {
    enum Constant {
        static let fontSize = CGFloat(14)
        static let verticalSpace = CGFloat(15)
        static let horizontalSpace = CGFloat(10)
        static let textSpace = CGFloat(10)
    }

    private var textView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 20
        view.backgroundColor = EDSColor.gloomyBrown.value
        view.isScrollEnabled = true
        view.isEditable = false
        view.textContainerInset = UIEdgeInsets(top: Constant.verticalSpace, left: Constant.horizontalSpace, bottom: Constant.verticalSpace, right: Constant.horizontalSpace)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    func placeText(text: String) {
        let range = NSRange(location: 0, length: text.count)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: EDSColor.skullLightWhite.value as Any, range: range)
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: Constant.fontSize), range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = Constant.textSpace
        paragraphStyle.alignment = .justified
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
        self.textView.attributedText = attributedString
    }

    func textViewHeight() -> CGFloat {
        let line = Int(Double(self.textView.text.count*11)/(self.view.frame.size.width*0.9-20))+1
        let length = Constant.verticalSpace*2 + Constant.fontSize + (Constant.fontSize+Constant.textSpace) * CGFloat(line-1)+5
        let maxLength = self.view.frame.size.height*0.35
        return length>maxLength ? maxLength : length
    }
}

extension RoomDescriptionViewController {
    func configure() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }

    func configureLayout() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.textView)
        NSLayoutConstraint.activate([
            self.textView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9),
            self.textView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.textView.heightAnchor.constraint(equalToConstant: self.textViewHeight())
        ])
    }
}
