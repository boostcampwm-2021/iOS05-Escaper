//
//  StoreDetailViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit
import CoreLocation

final class StoreDetailViewController: DefaultDIViewController<StoreDetailViewModelInterface> {
    private var store: Store?
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?
    private var storeTitleLabel: UILabel = EDSLabel.h01B(color: .pumpkin)
    private var infoDescriptionStackView = InfoDescriptionStackView(frame: .zero)
    private var roomOverViewTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = Constant.cellHeight
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.bindViewModel()
        guard let store = store else { return }
        self.inject(store: store)
        self.viewModel.fetchRooms(ids: store.roomIds)
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    func create(store: Store, viewModel: StoreDetailViewModelInterface) {
        self.store = store
        self.viewModel = viewModel
    }
}

extension StoreDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let room = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let repository = RoomDetailRepository(service: FirebaseService.shared)
        let usecase = RoomDetailUseCase(repository: repository)
        let viewModel = DefaultRoomDetailViewModel(usecase: usecase)
        let roomDetailViewController = RoomDetailViewController(viewModel: viewModel)
        roomDetailViewController.update(roomId: room.roomId)
        self.navigationController?.pushViewController(roomDetailViewController, animated: true)
    }
}

private extension StoreDetailViewController {
    enum Constant {
        static let sideSpace = CGFloat(20)
        static let topSpace = CGFloat(10)
        static let cellHeight = CGFloat(96)
    }

    enum Section {
        case main
    }

    func configure() {
        self.configureDelegates()
        self.configureStoreTitleLabelLayout()
        self.configureInfoDescriptionStackViewLayout()
        self.configureRoomOverViewTableViewLayout()
        self.configureRoomOverViewTableView()
    }

    func configureDelegates() {
        self.roomOverViewTableView.delegate = self
    }

    func configureStoreTitleLabelLayout() {
        self.storeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.storeTitleLabel)
        NSLayoutConstraint.activate([
            self.storeTitleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.sideSpace),
            self.storeTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constant.topSpace)
        ])
    }

    func configureInfoDescriptionStackViewLayout() {
        self.infoDescriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.infoDescriptionStackView)
        NSLayoutConstraint.activate([
            self.infoDescriptionStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Constant.sideSpace),
            self.infoDescriptionStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Constant.sideSpace),
            self.infoDescriptionStackView.topAnchor.constraint(equalTo: self.storeTitleLabel.bottomAnchor, constant: Constant.topSpace)
        ])
    }

    func configureRoomOverViewTableViewLayout() {
        self.roomOverViewTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.roomOverViewTableView)
        NSLayoutConstraint.activate([
            self.roomOverViewTableView.topAnchor.constraint(equalTo: self.infoDescriptionStackView.bottomAnchor, constant: Constant.topSpace),
            self.roomOverViewTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.roomOverViewTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.roomOverViewTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureRoomOverViewTableView() {
        self.roomOverViewTableView.register(RoomOverviewTableViewCell.self, forCellReuseIdentifier: RoomOverviewTableViewCell.identifier)
        self.dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: self.roomOverViewTableView) { (tableView: UITableView, _: IndexPath, room: Room) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomOverviewTableViewCell.identifier) as? RoomOverviewTableViewCell
            cell?.update(room)
            return cell
        }
    }

    func inject(store: Store) {
        self.storeTitleLabel.text = store.name
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "위치", content: store.region.krName))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "테마 개수", content: "\(store.roomIds.count)개"))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "거리", content: "\(Helper.measureDistance(store.distance))"))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "주소", content: store.address))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "전화번호", content: store.telephone, shouldOpen: true))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "홈페이지", content: store.homePage, shouldOpen: true))
    }

    func bindViewModel() {
        self.viewModel.rooms.observe(on: self, observerBlock: { rooms in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(rooms)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        })
    }
}
