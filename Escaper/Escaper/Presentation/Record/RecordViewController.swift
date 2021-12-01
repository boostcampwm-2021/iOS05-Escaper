//
//  RecordViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit
import AVFoundation

class RecordViewController: DefaultViewController {
    private typealias Datasource = UICollectionViewDiffableDataSource<Section, RecordCard>

    private var viewModel: RecordViewModel?
    private var datasource: Datasource?
    private let titleLabel: UILabel = {
        let label: UILabel = EDSLabel.h01B(text: "탈출 기록", color: .skullWhite)
        label.textAlignment = .center
        return label
    }()
    private let countingLabel: UILabel = {
        let label = UILabel()
        label.textColor = EDSColor.pumpkin.value
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let greetingLabel: UILabel = {
        let label: UILabel = EDSLabel.b02B(text: "", color: .skullWhite)
        label.textAlignment = .center
        return label
    }()
    private let recordCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.size.width*0.1, bottom: 0, right: UIScreen.main.bounds.size.width*0.1)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    private let addButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.setTitleColor(EDSColor.bloodyBlack.value, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = EDSColor.pumpkin.value
        button.layer.cornerRadius = 10
        button.isHidden = true
        return button
    }()
    private let recordEmptyGuideView: RecordEmptyGuideView = {
        let view = RecordEmptyGuideView()
        view.isHidden = true
        return view
    }()
    private let recordDefaultGuideView: RecordDefaultGuideView = {
        let view = RecordDefaultGuideView()
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserSupervisor.shared.isLogined {
            guard let userName = Helper.parseUsername(email: UserSupervisor.shared.email), let records = self.viewModel?.records.value else { return }
            if !records.allSatisfy({ $0.username == userName }) {
                self.viewModel?.records.value = []
                self.applyRecordCollectionViewData(recordCards: [], animated: false)
            }
            self.viewModel?.fetch(userEmail: UserSupervisor.shared.email)
        } else {
            self.recordDefaultGuideView.isHidden = false
            self.recordEmptyGuideView.isHidden = true
            self.addButton.isHidden = true
            self.countingLabel.text = "👻"
            self.greetingLabel.text = "당신의 실력은 어느 수준일까요?"
            self.viewModel?.records.value = []
            self.applyRecordCollectionViewData(recordCards: [], animated: false)
        }
    }

    func create(viewModel: RecordViewModel) {
        self.viewModel = viewModel
    }

    func bindViewModel() {
        self.viewModel?.records.observe(on: self) { [weak self] results in
            guard UserSupervisor.shared.isLogined else { return }
            if results.isEmpty {
                self?.recordDefaultGuideView.isHidden = true
                self?.recordEmptyGuideView.isHidden = false
                self?.addButton.isHidden = false
                self?.countingLabel.text = "💀"
                self?.greetingLabel.text = "기록하고, 탈출한 방의 랭커가 되어봐요!"
                self?.applyRecordCollectionViewData(recordCards: results, animated: false)
            } else {
                self?.recordDefaultGuideView.isHidden = true
                self?.recordEmptyGuideView.isHidden = true
                self?.addButton.isHidden = false
                self?.applyRecordCollectionViewData(recordCards: results, animated: true)
                self?.configureRecordSummary(count: results.count)
            }
            if self?.recordCollectionView.numberOfItems(inSection: .zero) != .zero {
                self?.recordCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
        }
    }
}

extension RecordViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width*0.8, height: Constant.deviceHeight*0.55)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludingSpacing = UIScreen.main.bounds.size.width*0.8 + CGFloat(10)
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        self.hapticsGenerator()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthIncludingSpacing = UIScreen.main.bounds.size.width*0.8 + CGFloat(10)
        let offsetX = self.recordCollectionView.contentOffset.x
        let index = (offsetX + self.recordCollectionView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: Section.card.index)
        if let cell = self.recordCollectionView.cellForItem(at: indexPath) {
            self.animateZoomforCell(zoomCell: cell)
        }
        if Int(roundedIndex) != 0 {
            let index = Int(roundedIndex) - 1
            let indexPath = IndexPath(item: index, section: Section.card.index)
            if let previousCell = self.recordCollectionView.cellForItem(at: indexPath) {
                self.animateZoomforCellremove(zoomCell: previousCell)
            }
        }
        if Int(roundedIndex) != self.recordCollectionView.numberOfItems(inSection: Section.card.index)-1 {
            let index = Int(roundedIndex) + 1
            let indexPath = IndexPath(item: index, section: Section.card.index)
            if let nextCell = self.recordCollectionView.cellForItem(at: indexPath) {
                self.animateZoomforCellremove(zoomCell: nextCell)
            }
        }
    }
}

extension RecordViewController: RecordDefaultGuideViewDelegate {
    func loginButtonTouched() {
        let loginViewController = LoginViewController()
        let userRepository = UserRepository(service: FirebaseService.shared)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = DefaultLoginViewModel(usecase: userUsecase)
        loginViewController.create(delegate: self, viewModel: viewModel)
        self.present(loginViewController, animated: true)
    }

    func signUpButtonTouched() {
        let signUpViewController = SignUpViewController()
        let userRepository = UserRepository(service: FirebaseService.shared)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = DefaultSignUpViewModel(usecase: userUsecase)
        signUpViewController.create(delegate: self, viewModel: viewModel)
        self.present(signUpViewController, animated: true)
    }
}

extension RecordViewController: LoginViewControllerDelegate, SignUpViewControllerDelegate {
    func loginSuccessed() {
        self.viewModel?.fetch(userEmail: UserSupervisor.shared.email)
    }

    func signUpSuccessed() {
        self.viewModel?.fetch(userEmail: UserSupervisor.shared.email)
    }
}

private extension RecordViewController {
    enum Constant {
        static let deviceHeight = UIScreen.main.bounds.size.height
        static let topBottomVerticalSpace = deviceHeight * 0.04
        static let defaultVerticalSpace = deviceHeight * 0.015
        static let collectionViewHeight = deviceHeight * 0.55
        static let buttonHeight = deviceHeight * 0.06
        static let longHorizontalSpace = CGFloat(120)
        static let shortHorizontalSpace = CGFloat(60)
    }

    enum GreetingMessage: String {
        case level0 = "방탈출이 처음이시군요!"
        case level1 = "방탈출 세계에 입문하신걸 축하드립니다!"
        case level2 = "조금만 더 하면 나도 방탈출 고수!"
        case level3 = "이정도면, 왠만한 방은 거의 탈출해보셨겠는걸요?"

        var value: String {
            return self.rawValue
        }
    }

    enum Section: Int {
        case card = 0

        var index: Int {
            return self.rawValue
        }
    }

    func configure() {
        self.configureAddButton()
        self.configureRecordCollectionView()
        self.configureRecordCollectionViewDataSource()
    }

    func configureLayout() {
        self.configureTitleLabelLayout()
        self.configureCountingLabelLayout()
        self.configureGreetingLabelLayout()
        self.configureRecordCollectionViewLayout()
        self.configureAddButtonLayout()
        self.configureRecordDefaultGuideViewConstraint()
        self.configureRecordEmptyGuideViewConstraint()

    }

    func configureRecordCollectionView() {
        self.recordCollectionView.delegate = self
        self.datasource = Datasource(collectionView: self.recordCollectionView) { (collectionView, indexPath, recordCard) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCollectionViewCell.identifier, for: indexPath) as? RecordCollectionViewCell else { return UICollectionViewCell() }
            cell.update(recordCard: recordCard)
            return cell
        }
        self.recordCollectionView.register(RecordCollectionViewCell.self, forCellWithReuseIdentifier: RecordCollectionViewCell.identifier)
    }

    func configureAddButton() {
        self.addButton.addTarget(self, action: #selector(self.addButtonTapped), for: .touchUpInside)
    }

    func applyRecordCollectionViewData(recordCards: [RecordCard], animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecordCard>()
        snapshot.appendSections([Section.card])
        snapshot.appendItems(recordCards)
        self.datasource?.apply(snapshot, animatingDifferences: animated)
        if recordCards.count > 1 {
            let indexPath = IndexPath(item: 1, section: Section.card.index)
            if let cell = self.recordCollectionView.cellForItem(at: indexPath) {
                animateZoomforCellremove(zoomCell: cell)
            }
        }
    }

    func configureRecordCollectionViewDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecordCard>()
        snapshot.appendSections([Section.card])
        snapshot.appendItems([], toSection: Section.card)
        self.datasource?.apply(snapshot, animatingDifferences: false)
    }

    func configureRecordSummary(count: Int) {
        self.countingLabel.text = String(count)
        switch count {
        case 0:
            self.greetingLabel.text = GreetingMessage.level0.value
        case 1..<10:
            self.greetingLabel.text = GreetingMessage.level1.value
        case 10..<25:
            self.greetingLabel.text = GreetingMessage.level2.value
        default:
            self.greetingLabel.text = GreetingMessage.level3.value
        }
    }

    func configureTitleLabelLayout() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.defaultVerticalSpace),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace)
        ])
    }

    func configureCountingLabelLayout() {
        self.countingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.countingLabel)
        NSLayoutConstraint.activate([
            self.countingLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.countingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.longHorizontalSpace),
            self.countingLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.longHorizontalSpace)
        ])
    }

    func configureGreetingLabelLayout() {
        self.greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.greetingLabel)
        NSLayoutConstraint.activate([
            self.greetingLabel.topAnchor.constraint(equalTo: self.countingLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.greetingLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.shortHorizontalSpace),
            self.greetingLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.shortHorizontalSpace)
        ])
    }

    func configureRecordCollectionViewLayout() {
        self.recordCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.recordCollectionView)
        NSLayoutConstraint.activate([
            self.recordCollectionView.topAnchor.constraint(equalTo: self.greetingLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.recordCollectionView.heightAnchor.constraint(equalToConstant: Constant.collectionViewHeight),
            self.recordCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.recordCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureAddButtonLayout() {
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addButton)
        NSLayoutConstraint.activate([
            self.addButton.topAnchor.constraint(equalTo: self.recordCollectionView.bottomAnchor, constant: Constant.topBottomVerticalSpace),
            self.addButton.heightAnchor.constraint(equalToConstant: Constant.buttonHeight),
            self.addButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constant.shortHorizontalSpace),
            self.addButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.shortHorizontalSpace)
        ])
    }

    func configureRecordDefaultGuideViewConstraint() {
        self.recordDefaultGuideView.delegate = self
        self.recordDefaultGuideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.recordDefaultGuideView)
        NSLayoutConstraint.activate([
            self.recordDefaultGuideView.topAnchor.constraint(equalTo: self.greetingLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.recordDefaultGuideView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordDefaultGuideView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.recordDefaultGuideView.heightAnchor.constraint(equalTo: self.recordDefaultGuideView.widthAnchor, multiplier: 1.5)
        ])
    }

    func configureRecordEmptyGuideViewConstraint() {
        self.recordEmptyGuideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.recordEmptyGuideView)
        NSLayoutConstraint.activate([
            self.recordEmptyGuideView.topAnchor.constraint(equalTo: self.greetingLabel.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.recordEmptyGuideView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordEmptyGuideView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.recordEmptyGuideView.heightAnchor.constraint(equalTo: self.recordEmptyGuideView.widthAnchor, multiplier: 1.5)
        ])
    }

    @objc func addButtonTapped() {
        let addRecordViewController = AddRecordViewController()
        let recordRepository = RecordRepository(service: FirebaseService.shared)
        let roomRepository = RoomListRepository(service: FirebaseService.shared)
        let userRepository = UserRepository(service: FirebaseService.shared)
        let recordUsecase = RecordUsecase(roomRepository: roomRepository, recordRepository: recordRepository)
        let userUsecase = UserUseCase(userRepository: userRepository)
        let viewModel = AddRecordViewModel(recordUsecase: recordUsecase, userUsecase: userUsecase)
        addRecordViewController.create(viewModel: viewModel)
        addRecordViewController.modalPresentationStyle = .fullScreen
        self.present(addRecordViewController, animated: true)
    }

    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.2,
                        delay: 0,
                        options: .curveEaseOut,
                        animations: {
                            zoomCell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        },
                        completion: nil)
    }

    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(withDuration: 0,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                            zoomCell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                       },
                       completion: nil)
    }

    func hapticsGenerator() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
