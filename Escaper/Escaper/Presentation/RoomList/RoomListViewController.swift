//
//  RoomListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit

final class RoomListViewController: DefaultViewController {
    enum Constant {
        static let tagViewHeight = CGFloat(30)
        static let cellHeight = CGFloat(65)
        static let topVerticalSpace = CGFloat(18)
        static let defaultVerticalSpace = CGFloat(13)
        static let defaultOutlineSpace = CGFloat(14)
    }

    enum Section {
        case main
    }

    private var viewModel: RoomListViewModelInterface!
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
        tableView.rowHeight = Constant.cellHeight
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Section, Room>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureGenreTagScrollViewLayout()
        self.configureSortingOptionTagScrollViewLayout()
        self.configureRoomOverviewTableViewLayout()
        self.configureDelegates()
        self.configureDataSource()
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
            self.viewModel.fetch(genre: genre, sortingOption: sortingOption)
        case let sortingOption as SortingOption:
            self.viewModel.sort(option: sortingOption)
        default:
            break
        }
    }
}

private extension RoomListViewController {
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
            self.sortingOptionTagScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
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

    func configureDataSource() {
        self.dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: roomOverviewTableView) { (tableView: UITableView, _: IndexPath, room: Room) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RoomOverviewTableViewCell.identifier) as? RoomOverviewTableViewCell
            cell?.update(room)
            return cell
        }
    }

    func configureDelegates() {
        self.genreTagScrollView.tagDelegate = self
        self.sortingOptionTagScrollView.tagDelegate = self
    }

    func injectTagScrollViewElements() {
        self.sortingOptionTagScrollView.inject(elements: SortingOption.allCases)
        self.genreTagScrollView.inject(elements: Genre.allCases)
    }

    func bindViewModel() {
        self.viewModel.rooms.observe(on: self) { roomList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(roomList)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
