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
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
    }

    func create() {
        let recordRepository = RecordRepository(service: FirebaseService.shared)
        let roomRepository = RoomListRepository(service: FirebaseService.shared)
        let usecase = RecordUsecase(roomRepository: roomRepository, recordRepository: recordRepository)
        let viewModel = AddRecordViewModel(usecase: usecase)
        self.viewModel = viewModel
    }

    @objc func backButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func saveRecordButtonTapped() {
        let userEmail = UIDevice.current.name
        guard let roomId = self.viewModel?.roomId else { return }
        let image = self.recordView.fetchSelectedImage()
        ImageCacheManager.shared.uploadRecord(image: image, userEmail: userEmail, roomId: roomId) { [weak self] result in
            switch result {
            case .success(let urlString):
                self?.viewModel?.post(email: userEmail, imageURLString: urlString)
                self?.dismiss(animated: true)
            case .failure(let err):
                print(err)
            }
        }
    }
}

extension AddRecordViewController: AddRecordViewDelegate {
    func updateEscapingTime(time: Int) {
        self.viewModel?.time = time
        self.viewModel?.changeSaveState()
    }

    func updateRoom(identifer: String) {
        self.viewModel?.roomId = identifer
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
        self.present(imagePickerController, animated: true)
    }

    func escapingTimePickerButtonTapped() {
        let timePickerController = TimePickerViewController()
        timePickerController.delegate = self
        self.present(timePickerController, animated: true)
    }
}

extension AddRecordViewController: TimePickerDelegate {
    func updateTime(hour: Int, minutes: Int, seconds: Int) {
        self.recordView.updateTimePicker(hour: hour, minutes: minutes, seconds: seconds)
    }
}

extension AddRecordViewController: RoomInformationTransferable {
    func transfer(room: Room) {
        self.recordView.updateRoomInformation(room)
        self.viewModel?.records = room.records
    }
}

extension AddRecordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        self.recordView.updateUserSelectedImage(image)
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
