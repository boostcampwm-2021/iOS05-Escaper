//
//  TagScrollView.swift
//  Escaper
//
//  Created by shinheeRo on 2021/11/03.
//

import UIKit

protocol TagScrollViewDelegate: AnyObject {
    func tagSelected(element: Tagable)
}

final class TagScrollView: UIScrollView {
    weak var tagDelegate: TagScrollViewDelegate?

    private(set) var selectedButton: TagButton?
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constant.tagSpace
        stackView.distribution = .fill
        return stackView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }

    func inject(elements: [Tagable]) {
        elements.forEach { element in
            let button = TagButton(element: element)
            let width = self.calculateStringWidth(text: element.name) + Constant.tagElementExtraSpace
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.addTarget(self, action: #selector(buttonTouched(sender:)), for: .touchUpInside)
            self.stackView.addArrangedSubview(button)
        }
        if let first = self.stackView.arrangedSubviews.first as? TagButton {
            self.selectedButton = first
            self.selectedButton?.touched()
        }
        injectExtraView(index: 0)
        injectExtraView(index: elements.count+1)
    }
}

private extension TagScrollView {
    enum Constant {
        static let tagSpace = CGFloat(8)
        static let tagElementExtraSpace = CGFloat(16)
        static let extraViewSpace = CGFloat(12)
    }

    func configureLayout() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.frameLayoutGuide.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.frameLayoutGuide.bottomAnchor)
        ])
    }

    @objc func buttonTouched(sender: TagButton) {
        guard self.selectedButton !== sender,
              let element = sender.element else { return }
        self.selectedButton?.untouched()
        self.selectedButton = sender
        self.selectedButton?.touched()
        self.tagDelegate?.tagSelected(element: element)
    }

    func calculateStringWidth(text: String) -> CGFloat {
        let temporaryLabel = UILabel()
        temporaryLabel.text = text
        return CGFloat(temporaryLabel.intrinsicContentSize.width)
    }

    func injectExtraView(index: Int) {
        let extraView = UIView()
        extraView.widthAnchor.constraint(equalToConstant: Constant.extraViewSpace).isActive = true
        self.stackView.insertArrangedSubview(extraView, at: index)
    }
}
