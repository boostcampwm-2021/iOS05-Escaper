//
//  RoomListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit
import CoreLocation

final class RoomListViewController: DefaultViewController {
    enum Constant {
        static let localeIdentifier = "Ko-kr"
        static let tagViewHeight = CGFloat(30)
        static let cellHeight = CGFloat(96)
        static let topVerticalSpace = CGFloat(18)
        static let defaultVerticalSpace = CGFloat(13)
        static let defaultOutlineSpace = CGFloat(14)
        static let defaultSortingOptionTrailingSpace = CGFloat(160)
    }

    enum Section {
        case main
    }

    private var viewModel: RoomListViewModelInterface?
    private let genreTagScrollView: TagScrollView = {
        let tagScrollView: TagScrollView = TagScrollView()
        tagScrollView.showsHorizontalScrollIndicator = false
        return tagScrollView
    }()
    private let sortingOptionTagScrollView: TagScrollView = {
        let tagScrollView: TagScrollView = TagScrollView()
        tagScrollView.showsHorizontalScrollIndicator = false
        return tagScrollView
    }()
    private let roomOverviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = Constant.cellHeight
        return tableView
    }()
    private var locationManager: CLLocationManager?
    private lazy var addressButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: UtilityImage.chevronDown.name), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitleColor(EDSColor.pumpkin.value, for: .normal)
        button.backgroundColor = EDSColor.bloodyBlack.value
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.configureLayout()
        self.injectTagScrollViewElements()
        self.bindViewModel()
    }

    func create() {
        let repository = RoomListRepository(service: FirebaseService.shared)
        let usecase = RoomListUseCase(repository: repository)
        let viewModel = DefaultRoomListViewModel(usecase: usecase)
        self.viewModel = viewModel
    }
}

extension RoomListViewController: TagScrollViewDelegate {
    func tagSelected(element: Tagable) {
        switch element {
        case let genre as Genre:
            guard let sortingOption = self.sortingOptionTagScrollView.selectedButton?.element as? SortingOption else { return }
            self.fetchCurrentDistrict { [weak self] district in
                self?.viewModel?.fetch(district: district, genre: genre, sortingOption: sortingOption)
            }
        case let sortingOption as SortingOption:
            self.viewModel?.sort(option: sortingOption)
        default:
            break
        }
    }
}

extension RoomListViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var status: CLAuthorizationStatus?
        if #available(iOS 14.0, *) {
            status = self.locationManager?.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        guard let status = status else { return }
        switch status {
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            guard let genre = self.genreTagScrollView.selectedButton?.element as? Genre,
                  let sortingOption = self.sortingOptionTagScrollView.selectedButton?.element as? SortingOption else { return }
            self.fetchCurrentDistrict { [weak self] district in
                if let buttonTitle = self?.buttonTitle(district: district.name) {
                    self?.addressButton.setTitle(buttonTitle, for: .normal)
                }
                self?.viewModel?.fetch(district: district, genre: genre, sortingOption: sortingOption)
            }
        default:
            break
        }
    }
}

extension RoomListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let addressButtonTitle = District.allCases.map({ $0.name })
            let addressButtonActions = addressButtonTitle
               .enumerated()
               .map { _, title in
                 return UIAction(title: title) { _ in
                     guard let district = District(rawValue: title),
                           let genre = self.genreTagScrollView.selectedButton?.element as? Genre,
                           let sortingOption = self.sortingOptionTagScrollView.selectedButton?.element as? SortingOption else { return }
                     let buttonTitle = self.buttonTitle(district: district.name)
                     self.addressButton.setTitle(buttonTitle, for: .normal)
                     self.viewModel?.fetch(district: district, genre: genre, sortingOption: sortingOption)
                 }
               }
             return UIMenu(title: "", children: addressButtonActions)
           }
        return configuration
    }
}

private extension RoomListViewController {
    func configure() {
        self.configureLocationManager()
        self.configureDelegates()
        self.configureDataSource()
        self.configureAddressButton()
    }

    func configureLayout() {
        self.configureGenreTagScrollViewLayout()
        self.configureSortingOptionTagScrollViewLayout()
        self.configureRoomOverviewTableViewLayout()
        self.configureAddressButtonLayout()
    }

    func configureGenreTagScrollViewLayout() {
        self.genreTagScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.genreTagScrollView)
        NSLayoutConstraint.activate([
            self.genreTagScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.topVerticalSpace),
            self.genreTagScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.genreTagScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.genreTagScrollView.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }

    func configureSortingOptionTagScrollViewLayout() {
        self.sortingOptionTagScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.sortingOptionTagScrollView)
        NSLayoutConstraint.activate([
            self.sortingOptionTagScrollView.topAnchor.constraint(equalTo: self.genreTagScrollView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.sortingOptionTagScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.sortingOptionTagScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.defaultSortingOptionTrailingSpace),
            self.sortingOptionTagScrollView.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }

    func configureRoomOverviewTableViewLayout() {
        self.roomOverviewTableView.translatesAutoresizingMaskIntoConstraints = false
        self.roomOverviewTableView.register(RoomOverviewTableViewCell.self,
                           forCellReuseIdentifier: RoomOverviewTableViewCell.identifier)
        self.view.addSubview(self.roomOverviewTableView)
        NSLayoutConstraint.activate([
            self.roomOverviewTableView.topAnchor.constraint(equalTo: self.sortingOptionTagScrollView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.roomOverviewTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.roomOverviewTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.roomOverviewTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureAddressButtonLayout() {
        self.addressButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addressButton)
        NSLayoutConstraint.activate([
            self.addressButton.topAnchor.constraint(equalTo: self.genreTagScrollView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.addressButton.leadingAnchor.constraint(equalTo: self.sortingOptionTagScrollView.trailingAnchor),
            self.addressButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.addressButton.bottomAnchor.constraint(equalTo: self.roomOverviewTableView.topAnchor, constant: -Constant.defaultVerticalSpace)
        ])
    }

    func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: roomOverviewTableView) { (tableView: UITableView, _: IndexPath, room: Room) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomOverviewTableViewCell.identifier) as? RoomOverviewTableViewCell
            cell?.update(room)
            return cell
        }
    }

    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
    }

    func configureDelegates() {
        self.genreTagScrollView.tagDelegate = self
        self.sortingOptionTagScrollView.tagDelegate = self
    }

    func configureAddressButton() {
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addressButton.addInteraction(interaction)
    }

    func injectTagScrollViewElements() {
        self.sortingOptionTagScrollView.inject(elements: SortingOption.allCases)
        self.genreTagScrollView.inject(elements: Genre.allCases)
    }

    func bindViewModel() {
        self.viewModel?.rooms.observe(on: self) { roomList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(roomList)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    func fetchCurrentDistrict(completion: @escaping (District) -> Void) {
        guard let location = self.locationManager?.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: Constant.localeIdentifier)
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) {  placeMarks, _ in
            guard let address: [CLPlacemark] = placeMarks,
                  let locality = address.last?.locality,
                  let district = District.init(rawValue: locality) else { return }
            completion(district)
        }
    }

    func buttonTitle(district: String) -> String {
        return district + " 기준 "
    }
}
