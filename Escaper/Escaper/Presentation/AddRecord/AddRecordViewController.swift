//
//  AddRecordViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/09.
//

import UIKit

final class AddRecordViewController: DefaultViewController {
    private var viewModel: (AddRecordViewModelInput & AddRecordViewModelOutput)?
    private let titleLabel: UILabel = EDSLabel.h02B(text: "기록 추가", color: .skullLightWhite)
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(EDSColor.bloodyRed.value, for: .normal)
        return button
    }()
    private let recordView = AddRecordView()
    private let saveRecordButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.backgroundColor = EDSColor.skullGrey.value
        button.isEnabled = false
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
    }

    func create(viewModel: AddRecordViewModelInput & AddRecordViewModelOutput) {
        self.viewModel = viewModel
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func saveRecordButtonTapped() {
        let userEmail = UserSupervisor.shared.email
        guard let roomId = self.viewModel?.room?.roomId else { return }
        let image = self.recordView.fetchSelectedImage()
        ImageUploader.shared.uploadRecord(image: image, userEmail: userEmail, roomId: roomId) { [weak self] result in
            switch result {
            case .success(let urlString):
                self?.viewModel?.post(email: userEmail, imageURLString: urlString)
                self?.dismiss(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AddRecordViewController: AddRecordViewDelegate {
    func updateRating(_ value: Double) {
        self.viewModel?.satisfaction = value
    }

    func updateEscapingTime(time: Int) {
        self.viewModel?.time = time
        self.viewModel?.changeSaveState()
    }

    func updateIsSuccess(_ isSuccess: Bool) {
        self.viewModel?.isSuccess = isSuccess
    }

    func findRoomTitleButtonTapped() {
        let findRoomViewController = SearchRoomViewController()
        findRoomViewController.create()
        findRoomViewController.modalPresentationStyle = .automatic
        findRoomViewController.roomTransferDelegate = self
        self.present(findRoomViewController, animated: true)
    }

    func userImageViewTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true)
    }

    func escapingTimePickerButtonTapped() {
        let timePickerController = TimePickerViewController()
        timePickerController.timeLimit = self.viewModel?.room?.timeLimit
        timePickerController.delegate = self
        self.present(timePickerController, animated: true)
    }
}

extension AddRecordViewController: TimePickerDelegate {
    func updateTime(minutes: Int, seconds: Int) {
        self.recordView.updateTimePicker(minutes: minutes, seconds: seconds)
    }
}

extension AddRecordViewController: RoomInformationTransferable {
    func transfer(room: Room) {
        guard let isVisited = self.viewModel?.updateRoom(room) else { return }
        if isVisited {
            self.recordView.updateRoomInformation(room)
        } else {
            let alert = UIAlertController(title: "경고", message: "이미 다녀온 테마입니다.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .destructive)
            alert.addAction(defaultAction)
            self.present(alert, animated: false, completion: nil)
        }
    }
}

extension AddRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        var newImage: UIImage?
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = selectedImage
        } else if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = selectedImage
        }
        self.recordView.updateUserSelectedImage(newImage)
    }
}

private extension AddRecordViewController {
    enum Constant {
        static let topVerticalSpace = CGFloat(18)
        static let defaultVerticalSpace = CGFloat(30)
        static let saveButtonHeight = CGFloat(50)
    }

    func configure() {
        self.configureDelegates()
        self.configureButtonAction()
        self.bindViewModel()
    }

    func configureLayout() {
        self.configureTitleLabelLayout()
        self.configureRecordViewLayout()
        self.configureBackButtonLayout()
        self.configureSaveButtonLayout()
        self.tabBarController?.tabBar.isHidden = true
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.topVerticalSpace),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }

    func configureRecordViewLayout() {
        self.recordView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.recordView)
        NSLayoutConstraint.activate([
            self.recordView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.recordView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordView.heightAnchor.constraint(equalTo: self.recordView.widthAnchor, multiplier: 1.5),
            self.recordView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.defaultVerticalSpace)
        ])
    }

    func configureBackButtonLayout() {
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.backButton)
        NSLayoutConstraint.activate([
            self.backButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.topVerticalSpace)
        ])
    }

    func configureSaveButtonLayout() {
        self.saveRecordButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.saveRecordButton)
        NSLayoutConstraint.activate([
            self.saveRecordButton.centerXAnchor.constraint(equalTo: self.recordView.centerXAnchor),
            self.saveRecordButton.topAnchor.constraint(equalTo: self.recordView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.saveRecordButton.widthAnchor.constraint(equalTo: self.recordView.widthAnchor, multiplier: 0.85),
            self.saveRecordButton.heightAnchor.constraint(equalToConstant: Constant.saveButtonHeight)
        ])
    }

    func configureDelegates() {
        self.recordView.delegate = self
    }

    func configureButtonAction() {
        self.backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        self.saveRecordButton.addTarget(self, action: #selector(self.saveRecordButtonTapped), for: .touchUpInside)
    }

    func bindViewModel() {
        self.viewModel?.state.observe(on: self) { [weak self] postableState in
            self?.saveRecordButton.isEnabled = postableState
            self?.saveRecordButton.backgroundColor = postableState ? EDSColor.pumpkin.value : EDSColor.skullGrey.value
        }
    }
}
