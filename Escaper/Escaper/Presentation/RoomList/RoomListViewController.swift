//
//  RoomListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit
import CoreLocation

final class RoomListViewController: DefaultDIViewController<RoomListViewModelInterface> {
    private var selectedDistrict: District?
    private var locationManager: CLLocationManager?
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?
    private var usernameLabel: UILabel = EDSLabel.h02B(color: .pumpkin)
    private var greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        let text = "오늘은 어디를 탈출할까요?"
        let attribtuedString = NSMutableAttributedString(string: text)
        let rangeFull = (text as NSString).range(of: text)
        attribtuedString.addAttribute(.foregroundColor, value: EDSColor.skullWhite.value ?? UIColor.white, range: rangeFull)
        let rangeWhere = (text as NSString).range(of: "어디")
        attribtuedString.addAttribute(.foregroundColor, value: EDSColor.pumpkin.value ?? UIColor.orange, range: rangeWhere)
        label.attributedText = attribtuedString
        return label
    }()
    private var greetingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private var districtSelectButton = DistrictSelectButton()
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
    private var emptyResultView: EmptyResultView = {
        let emptyResultView = EmptyResultView()
        emptyResultView.injectContentLabelText(text: "검색 결과가 없어요. 다른 지역을 선택해주세요.")
        emptyResultView.alpha = 0.5
        return emptyResultView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.injectTagScrollViewElements()
        self.bindViewModel()
        self.locationAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.applyUsernameLabelText()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension RoomListViewController: TagScrollViewDelegate {
    func tagSelected(element: Tagable) {
        switch element {
        case is Genre:
            let district = self.districtSelectButton.selectedDistrict ?? .none
            self.fetchWithCurrentSelectedOption(with: district)
        case let sortingOption as SortingOption:
            self.viewModel.sort(option: sortingOption)
        default:
            break
        }
    }
}

extension RoomListViewController: DistrictSelectViewDelegate {
    func districtDidSelected(district: District) {
        self.selectedDistrict = district
        self.fetchWithCurrentSelectedOption(with: district)
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
            self.fetchCurrentDistrict { [weak self] district in
                self?.districtSelectButton.updateTitle(district: district)
                self?.fetchWithCurrentSelectedOption(with: district)
            }
        default:
            break
        }
    }
}

extension RoomListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let room = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let roomListRepository = RoomListRepository(service: FirebaseService.shared)
        let userRepository = UserRepository(service: FirebaseService.shared)
        let usecase = RoomDetailUseCase(roomListRepository: roomListRepository, userRepository: userRepository)
        let viewModel = DefaultRoomDetailViewModel(usecase: usecase)
        let detailViewController = RoomDetailViewController(viewModel: viewModel)
        detailViewController.update(roomId: room.roomId)
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

private extension RoomListViewController {
    enum Constant {
        static let localeIdentifier = "Ko-kr"
        static let tagViewHeight = CGFloat(30)
        static let sideSpace = CGFloat(20)
        static let cellHeight = CGFloat(96)
        static let topVerticalSpace = CGFloat(18)
        static let topSmallVerticalSpace = CGFloat(10)
        static let defaultVerticalSpace = CGFloat(13)
        static let defaultOutlineSpace = CGFloat(14)
        static let districtSelectButtonWidth = CGFloat(105)
        static let sortingOptionWidth = CGFloat(230)
    }

    enum Section {
        case main
    }

    func configure() {
        self.configureLocationManager()
        self.configureDelegates()
        self.configureRoomOverViewTableView()
        self.configureGreetingStackViewLayout()
        self.configureGreetingStackView()
        self.configureGenreTagScrollViewLayout()
        self.configureSortingOptionTagScrollViewLayout()
        self.configureRoomOverviewTableViewLayout()
        self.configureDistrictSelectButtonLayout()
        self.configureEmptyImageViewLayout()
    }

    func configureGreetingStackViewLayout() {
        self.greetingStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.greetingStackView)
        NSLayoutConstraint.activate([
            self.greetingStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.topSmallVerticalSpace),
            self.greetingStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.sideSpace),
            self.greetingStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.sideSpace)
        ])
    }

    func configureGreetingStackView() {
        self.greetingStackView.addArrangedSubview(self.usernameLabel)
        self.greetingStackView.addArrangedSubview(self.greetingLabel)
    }

    func configureGenreTagScrollViewLayout() {
        self.genreTagScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.genreTagScrollView)
        NSLayoutConstraint.activate([
            self.genreTagScrollView.topAnchor.constraint(equalTo: self.greetingStackView.bottomAnchor, constant: Constant.topSmallVerticalSpace),
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
            self.sortingOptionTagScrollView.widthAnchor.constraint(equalToConstant: Constant.sortingOptionWidth),
            self.sortingOptionTagScrollView.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }

    func configureEmptyImageViewLayout() {
        self.emptyResultView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emptyResultView)
        NSLayoutConstraint.activate([
            self.emptyResultView.centerXAnchor.constraint(equalTo: self.roomOverviewTableView.centerXAnchor),
            self.emptyResultView.centerYAnchor.constraint(equalTo: self.roomOverviewTableView.centerYAnchor),
            self.emptyResultView.widthAnchor.constraint(equalTo: self.roomOverviewTableView.widthAnchor, multiplier: 0.8),
            self.emptyResultView.heightAnchor.constraint(equalTo: self.roomOverviewTableView.heightAnchor, multiplier: 0.25)
        ])
    }

    func configureRoomOverviewTableViewLayout() {
        self.roomOverviewTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.roomOverviewTableView)
        NSLayoutConstraint.activate([
            self.roomOverviewTableView.topAnchor.constraint(equalTo: self.sortingOptionTagScrollView.bottomAnchor, constant: Constant.defaultVerticalSpace),
            self.roomOverviewTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.roomOverviewTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.roomOverviewTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureDistrictSelectButtonLayout() {
        self.districtSelectButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.districtSelectButton)
        NSLayoutConstraint.activate([
            self.districtSelectButton.centerYAnchor.constraint(equalTo: self.sortingOptionTagScrollView.centerYAnchor),
            self.districtSelectButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constant.sideSpace),
            self.districtSelectButton.widthAnchor.constraint(equalToConstant: Constant.districtSelectButtonWidth),
            self.districtSelectButton.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }

    func configureRoomOverViewTableView() {
        self.roomOverviewTableView.register(RoomOverviewTableViewCell.self, forCellReuseIdentifier: RoomOverviewTableViewCell.identifier)
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
        self.roomOverviewTableView.delegate = self
        self.genreTagScrollView.tagDelegate = self
        self.sortingOptionTagScrollView.tagDelegate = self
        self.districtSelectButton.delegate = self
    }

    func injectTagScrollViewElements() {
        self.sortingOptionTagScrollView.inject(elements: SortingOption.allCases)
        self.genreTagScrollView.inject(elements: Genre.allCases)
    }

    func bindViewModel() {
        self.viewModel.rooms.observe(on: self) { [weak self] roomList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(roomList)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
            self?.emptyResultView.isHidden = roomList.isNotEmpty
        }
    }

    func fetchCurrentDistrict(completion: @escaping (District) -> Void) {
        guard let location = self.locationManager?.location else { return }
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: Constant.localeIdentifier)
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) {  placeMarks, _ in
            guard let address: [CLPlacemark] = placeMarks,
                  let locality = address.last?.locality else { return }
            let district = District.init(rawValue: locality) ?? .none
            completion(district)
        }
    }

    func fetchWithCurrentSelectedOption(with district: District) {
        guard let genre = self.genreTagScrollView.selectedButton?.element as? Genre,
              let sortingOption = self.sortingOptionTagScrollView.selectedButton?.element as? SortingOption else { return }
        self.viewModel.fetch(district: district, genre: genre, sortingOption: sortingOption)
    }

    func locationAuthorization() {
        if #available(iOS 14.0, *) {
            return
        } else {
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                self.fetchCurrentDistrict { [weak self] district in
                    self?.districtSelectButton.updateTitle(district: district)
                    self?.fetchWithCurrentSelectedOption(with: district)
                }
            default:
                break
            }
        }
    }

    func applyUsernameLabelText() {
        self.usernameLabel.isHidden = !UserSupervisor.shared.isLogined
        guard let username = Helper.parseUsername(email: UserSupervisor.shared.email) else { return }
        self.usernameLabel.text = "\(username)님,"
    }
}
