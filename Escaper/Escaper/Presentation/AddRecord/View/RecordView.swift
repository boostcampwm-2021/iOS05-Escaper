//
//  RecordView.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/10.
//

import UIKit

protocol RecordViewDelegate: AnyObject {
    func findRoomTitleButtonTapped()
    func userImageViewTapped()
    func escapingTimePickerButtonTapped()
    func updateRoom(identifer: String)
    func updateIsSuccess(_ isSuccess: Bool)
    func updateEscapingTime(time: Int)
}

class RecordView: UIView {
    enum Constant {
        static let stackViewSpacing = CGFloat(20)
    }

    private let recordBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = EDSImage.recordCard.value
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let userSelectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = EDSImage.plus.value
        imageView.backgroundColor = EDSColor.charcoal.value
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let findRoomTitleButton: UIButton = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: configuration), for: .normal)
        button.setTitle("방이름을 찾아주세요", for: .normal)
        button.setTitleColor(EDSColor.charcoal.value, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    private let roomStoreTitleLabel = EDSLabel.b01R(text: "업체정보", color: .charcoal)
    private let satisfactionLabel: UILabel = EDSLabel.b01B(text: "만족도", color: .charcoal)
    private let escapingStatusLabel = EDSLabel.b01B(text: "탈출 여부", color: .charcoal)
    private let escapingTimeLabel = EDSLabel.b01B(text: "탈출 시간", color: .charcoal)
    private let satisFactionRatingView = RatingView()
    private let escapingStatusSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Success", "Fail"])
        segmentControl.tintColor = .clear
        segmentControl.layer.backgroundColor = EDSColor.skullLightWhite.value!.cgColor
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = EDSColor.pumpkin.value
        return segmentControl
    }()
    private let escapingTimePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("00 : 00 : 00", for: .normal)
        button.setTitleColor(EDSColor.charcoal.value, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        button.backgroundColor = EDSColor.skullWhite.value
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        return button
    }()
    private let roomInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private let escapingInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.stackViewSpacing
        return stackView
    }()
    private let escapingInputStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = Constant.stackViewSpacing
        return stackView
    }()
    private let escapingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Constant.stackViewSpacing
        return stackView
    }()

    weak var delegate: RecordViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
        self.configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
        self.configureLayout()
    }

    @objc func findRoomButtonTouched() {
        self.delegate?.findRoomTitleButtonTapped()
    }

    @objc func escapingRoomButtonTouched() {
        self.delegate?.escapingTimePickerButtonTapped()
    }

    @objc func escapingStatusSegmentControlChanged() {
        let currentColor = self.escapingStatusSegmentControl.selectedSegmentIndex == 0 ? EDSColor.pumpkin : EDSColor.bloodyRed
        self.escapingStatusSegmentControl.selectedSegmentTintColor = currentColor.value
        self.delegate?.updateIsSuccess(self.escapingStatusSegmentControl.selectedSegmentIndex == 0)
    }

    @objc func userSelectedImageViewTapped() {
        self.delegate?.userImageViewTapped()
    }

    func updateRoomInformation(_ room: Room) {
        self.findRoomTitleButton.setTitle(room.name, for: .normal)
        self.findRoomTitleButton.setImage(nil, for: .normal)
        self.roomStoreTitleLabel.text = room.storeName
        self.delegate?.updateRoom(identifer: room.identifier)
    }

    func updateTimePicker(hour: Int, minutes: Int, seconds: Int) {
        let timeString = "\(String(format: "%02d", hour)) : \(String(format: "%02d", minutes)) : \(String(format: "%02d", seconds))"
        self.escapingTimePickerButton.setTitle(timeString, for: .normal)
        self.delegate?.updateEscapingTime(time: hour*3600 + minutes*60 + seconds)
    }

    func updateUserSelectedImage(_ image: UIImage) {
        self.userSelectedImageView.image = image
    }

    func fetchSelectedImage() -> UIImage? {
        return self.userSelectedImageView.image
    }
}

private extension RecordView {
    func configure() {
        self.configureImageViewEvent()
        self.configureAddTarget()
    }

    func configureLayout() {
        self.configureRecordBackgroundImageViewLayout()
        self.configureImagePickerButtonLayout()
        self.configurArrrangeSubViews()
        self.configureRatingViewLayout()
        self.configureEscapingtimePickerButtonLayout()
        self.configureRoomInformationStackViewLayout()
        self.configureEscapingStackViewLayout()
    }

    func configureRecordBackgroundImageViewLayout() {
        self.recordBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.recordBackgroundImageView)
        NSLayoutConstraint.activate([
            self.recordBackgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.recordBackgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.recordBackgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.recordBackgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureImagePickerButtonLayout() {
        self.userSelectedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.userSelectedImageView)
        NSLayoutConstraint.activate([
            self.userSelectedImageView.heightAnchor.constraint(equalTo: self.recordBackgroundImageView.heightAnchor, multiplier: 0.2),
            self.userSelectedImageView.widthAnchor.constraint(equalTo: self.userSelectedImageView.heightAnchor),
            self.userSelectedImageView.topAnchor.constraint(equalTo: self.recordBackgroundImageView.topAnchor, constant: 15),
            self.userSelectedImageView.centerXAnchor.constraint(equalTo: self.recordBackgroundImageView.centerXAnchor)
        ])
    }

    func configurArrrangeSubViews() {
        self.roomInformationStackView.addArrangedSubview(self.findRoomTitleButton)
        self.roomInformationStackView.addArrangedSubview(self.roomStoreTitleLabel)
        self.escapingInformationStackView.addArrangedSubview(self.satisfactionLabel)
        self.escapingInformationStackView.addArrangedSubview(self.escapingStatusLabel)
        self.escapingInformationStackView.addArrangedSubview(self.escapingTimeLabel)
        self.escapingInputStackView.addArrangedSubview(self.satisFactionRatingView)
        self.escapingInputStackView.addArrangedSubview(self.escapingStatusSegmentControl)
        self.escapingInputStackView.addArrangedSubview(self.escapingTimePickerButton)
        self.escapingStackView.addArrangedSubview(self.escapingInformationStackView)
        self.escapingStackView.addArrangedSubview(self.escapingInputStackView)
    }

    func configureRatingViewLayout() {
        self.satisFactionRatingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.satisFactionRatingView.heightAnchor.constraint(equalToConstant: 23),
            self.satisFactionRatingView.widthAnchor.constraint(equalToConstant: 23 * CGFloat(Rating.maxRating) + RatingView.Constant.summationOfElementSpacing)
        ])
    }

    func configureEscapingtimePickerButtonLayout() {
        self.escapingTimePickerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.escapingTimePickerButton.widthAnchor.constraint(equalTo: self.escapingInputStackView.widthAnchor, multiplier: 0.5)
        ])
    }

    func configureRoomInformationStackViewLayout() {
        self.roomInformationStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.roomInformationStackView)
        NSLayoutConstraint.activate([
            self.roomInformationStackView.topAnchor.constraint(equalTo: self.userSelectedImageView.bottomAnchor, constant: 30),
            self.roomInformationStackView.centerXAnchor.constraint(equalTo: self.recordBackgroundImageView.centerXAnchor),
            self.roomInformationStackView.widthAnchor.constraint(lessThanOrEqualTo: self.recordBackgroundImageView.widthAnchor)
        ])
    }

    func configureEscapingStackViewLayout() {
        self.escapingStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.escapingStackView)
        NSLayoutConstraint.activate([
            self.escapingStackView.centerXAnchor.constraint(equalTo: self.recordBackgroundImageView.centerXAnchor),
            self.escapingStackView.topAnchor.constraint(equalTo: self.roomInformationStackView.bottomAnchor, constant: 30),
            self.escapingStackView.widthAnchor.constraint(lessThanOrEqualTo: self.recordBackgroundImageView.widthAnchor)
        ])
    }

    func configureImageViewEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.userSelectedImageViewTapped))
        self.userSelectedImageView.addGestureRecognizer(tapGesture)
        self.userSelectedImageView.isUserInteractionEnabled = true
    }

    func configureAddTarget() {
        self.findRoomTitleButton.addTarget(self, action: #selector(self.findRoomButtonTouched), for: .touchUpInside)
        self.escapingTimePickerButton.addTarget(self, action: #selector(self.escapingRoomButtonTouched), for: .touchUpInside)
        self.escapingStatusSegmentControl.addTarget(self, action: #selector(self.escapingStatusSegmentControlChanged), for: .valueChanged)
    }
}
