//
//  TimePickerViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/11.
//

import UIKit

protocol TimePickerDelegate: AnyObject {
    func updateTime(hour: Int, minutes: Int, seconds: Int)
}

final class TimePickerViewController: UIViewController {
    weak var delegate: TimePickerDelegate?

    private var hour: Int = 0
    private var minutes: Int = 0
    private var seconds: Int = 0
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = EDSColor.gloomyBrown.value
        return view
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(EDSColor.bloodyRed.value, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(EDSColor.skullWhite.value, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.setValue(EDSColor.pumpkin.value, forKeyPath: "textColor")
        pickerView.backgroundColor = EDSColor.bloodyBlack.value
        return pickerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 25)
    }

    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func confirmButtonTapped() {
        self.delegate?.updateTime(hour: self.hour, minutes: self.minutes, seconds: self.seconds)
        self.dismiss(animated: true)
    }

    @objc func clearViewTapped(_ sender: UITapGestureRecognizer) {
        let tappedPoint = sender.location(in: self.containerView)
        guard self.containerView.hitTest(tappedPoint, with: nil) == nil else { return }
        self.delegate?.updateTime(hour: self.hour, minutes: self.minutes, seconds: self.seconds)
        self.dismiss(animated: true)
    }
}

private extension TimePickerViewController {
    func configure() {
        self.configureContainerViewLayout()
        self.configureButtonStackViewSubViews()
        self.configureButtonStackViewLayout()
        self.configurePickerViewLayout()
        self.configureButtonAction()
        self.configureTapGesture()
        self.pickerView.delegate = self
    }

    func configureContainerViewLayout() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.containerView)
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureButtonStackViewSubViews() {
        self.buttonStackView.addArrangedSubview(self.cancelButton)
        self.buttonStackView.addArrangedSubview(self.confirmButton)
    }

    func configureButtonStackViewLayout() {
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.buttonStackView)
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.buttonStackView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.buttonStackView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.85),
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func configurePickerViewLayout() {
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.pickerView)
        NSLayoutConstraint.activate([
            self.pickerView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor),
            self.pickerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.pickerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.pickerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }

    func configureButtonAction() {
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonTapped), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(self.confirmButtonTapped), for: .touchUpInside)
    }

    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clearViewTapped))
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
    }
}

extension TimePickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 3
        case 1, 2:
            return 60
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / 3
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            hour = row
        case 1:
            minutes = row
        case 2:
            seconds = row
        default:
            break
        }
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let color = EDSColor.skullWhite.value else { return NSAttributedString() }
        switch component {
        case 0:
            return NSAttributedString(string: "\(row) 시간", attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        case 1:
            return NSAttributedString(string: "\(row) 분", attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        case 2:
            return NSAttributedString(string: "\(row) 초", attributes: [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold)])
        default:
            return  NSAttributedString()
        }
    }
}
