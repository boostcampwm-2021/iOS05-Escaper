//
//  RecordViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

class RecordViewController: DefaultViewController {
    private enum Constant {
        static let deviceHeight = UIScreen.main.bounds.size.height
        static let topBottomVerticalSpace = deviceHeight * 0.04
        static let defaultVerticalSpace = deviceHeight * 0.015
        static let collectionViewHeight = deviceHeight * 0.55
        static let buttonHeight = deviceHeight * 0.06
        static let longHorizontalSpace = CGFloat(120)
        static let shortHorizontalSpace = CGFloat(60)
    }

    private enum GreetingMessage: String {
        var value: String {
            return self.rawValue
        }

        case level0 = "방탈출이 처음이시군요!"
        case level1 = "방탈출 세계에 입문하신걸 축하드립니다!"
        case level2 = "조금만 더 하면 나도 방탈출 고수!"
        case level3 = "이정도면, 왠만한 방은 거의 탈출해보셨겠는걸요?"
    }

    private enum Section: Int {
        var index: Int {
            return self.rawValue
        }

        case card = 0
    }

    private typealias Datasource = UICollectionViewDiffableDataSource<Section, Record>

    private var viewModel: RecordViewModel?
    private var datasource: Datasource?
    private let titleLabel: UILabel = {
        let label: UILabel = EDSLabel.h01B(text: "탈출 기록", color: .skullWhite)
        label.textAlignment = .center
        return label
    }()
    private let countingLabel: UILabel = {
        let label = UILabel()
        label.text = "15"
        label.textColor = EDSColor.pumpkin.value
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let greetingLabel: UILabel = {
        let label: UILabel = EDSLabel.b02B(text: GreetingMessage.level1.value, color: .skullWhite)
        label.textAlignment = .center
        return label
    }()
    private let recordCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = EDSColor.bloodyBlack.value
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
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        configure()
        configureLayout()
        bindViewModel()
    }

    func create() {
        let roomRepository = RoomListRepository(service: FirebaseService.shared)
        let recordRepository = RecordRepository(service: FirebaseService.shared)
        let usecase = RecordUsecase(roomRepository: roomRepository, recordRepository: recordRepository)
        let viewModel = DefaultRecordViewModel(useCase: usecase)
        self.viewModel = viewModel
    }

    func bindViewModel() {
        self.viewModel?.records.observe(on: self) { [weak self] result in
            self?.configureRecordCollectionViewData(records: result)
        }
        self.viewModel?.fetch(userEmail: "kessler.myah@hotmail.com")
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
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellWidthIncludingSpacing = UIScreen.main.bounds.size.width*0.8 + CGFloat(10)
        let offsetX = self.recordCollectionView.contentOffset.x
        let index = (offsetX + self.recordCollectionView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: Section.card.index)
        if let cell = self.recordCollectionView.cellForItem(at: indexPath) {
            animateZoomforCell(zoomCell: cell)
        }
        if Int(roundedIndex) != 0 {
            let index = Int(roundedIndex) - 1
            let indexPath = IndexPath(item: index, section: Section.card.index)
            if let previousCell = self.recordCollectionView.cellForItem(at: indexPath) {
                animateZoomforCellremove(zoomCell: previousCell)
            }
        }
        if Int(roundedIndex) != self.recordCollectionView.numberOfItems(inSection: Section.card.index)-1 {
            let index = Int(roundedIndex) + 1
            let indexPath = IndexPath(item: index, section: Section.card.index)
            if let nextCell = self.recordCollectionView.cellForItem(at: indexPath) {
                animateZoomforCellremove(zoomCell: nextCell)
            }
        }
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
}

extension RecordViewController {
    func configure() {
        configureRecordCollectionView()
    }

    func configureLayout() {
        configureTitleLabelLayout()
        configureCountingLabelLayout()
        configureGreetingLabelLayout()
        configureRecordCollectionViewLayout()
        configureAddButtonLayout()
    }

    func configureRecordCollectionView() {
        self.recordCollectionView.delegate = self
        self.datasource = Datasource(collectionView: self.recordCollectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecordCollectionViewCell.identifier, for: indexPath) as? RecordCollectionViewCell else { return UICollectionViewCell() }
            cell.update(record: itemIdentifier)
            return cell
        }
        self.recordCollectionView.register(RecordCollectionViewCell.self, forCellWithReuseIdentifier: RecordCollectionViewCell.identifier)
    }

    func configureRecordCollectionViewData(records: [Record]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Record>()
        snapshot.appendSections([Section.card])
        snapshot.appendItems(records, toSection: Section.card)
        self.datasource?.apply(snapshot, animatingDifferences: false)
        if records.count > 1 {
            let indexPath = IndexPath(item: 1, section: Section.card.index)
            if let cell = self.recordCollectionView.cellForItem(at: indexPath) {
                animateZoomforCellremove(zoomCell: cell)
            }
        }
        configureRecordSummary(count: records.count)
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
}
