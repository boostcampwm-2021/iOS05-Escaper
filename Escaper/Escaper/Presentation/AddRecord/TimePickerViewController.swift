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
        view.backgroundColor = EDSColor.bloodyBlack.value
        return view
    }()
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barTintColor = EDSColor.gloomyBrown.value
        return toolBar
    }()
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = EDSColor.gloomyBrown.value
        pickerView.setValue(EDSColor.pumpkin.value, forKeyPath: "textColor")
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

    @objc func cancelBarButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func confirmBarButtonTapped() {
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
        self.configureToolBarLayout()
        self.configurePickerViewLayout()
        self.configureToolBarItems()
        self.configureTapGesture()
        self.pickerView.delegate = self
    }

    func configureContainerViewLayout() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.containerView)
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureToolBarLayout() {
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.toolBar)
        NSLayoutConstraint.activate([
            self.toolBar.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.toolBar.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.toolBar.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.toolBar.heightAnchor.constraint(equalTo: self.containerView.heightAnchor, multiplier: 0.25)
        ])
    }

    func configurePickerViewLayout() {
        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.pickerView)
        NSLayoutConstraint.activate([
            self.pickerView.topAnchor.constraint(equalTo: self.toolBar.bottomAnchor),
            self.pickerView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.pickerView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.pickerView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }

    func configureToolBarItems() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelBarButtonTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let save = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(self.confirmBarButtonTapped))
        cancel.tintColor = EDSColor.bloodyRed.value
        save.tintColor = EDSColor.skullWhite.value
        self.toolBar.items = [cancel, spacer, save]
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
