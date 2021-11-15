//
//  FindRoomViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/10.
//

import UIKit

protocol RoomInformationTransferable: AnyObject {
    func transfer(room: Room)
}

class FindRoomViewController: UIViewController {
    enum Constant {
        static let verticalSpace = CGFloat(20)
    }

    enum Section {
        case main
    }

    private var viewModel: (FindRoomViewModelInput & FindRoomViewModelOutput)?
    private var searchRequestWorkItem: DispatchWorkItem?
    weak var roomTransferDelegate: RoomInformationTransferable?
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = EDSColor.gloomyBrown.value
        return view
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    private let roomListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    private var dataSource: UITableViewDiffableDataSource<Section, Room>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerView.roundCorners(corners: [.topLeft, .topRight], radius: 50)
    }

    func create() {
        let repository = RoomListRepository(service: FirebaseService.shared)
        let usecase = RoomListUseCase(repository: repository)
        let viewModel = FindRoomViewModel(usecase: usecase)
        self.viewModel = viewModel
    }

    @objc func clearViewTapped(_ sender: UITapGestureRecognizer) {
        let tappedPoint = sender.location(in: self.containerView)
        guard self.containerView.hitTest(tappedPoint, with: nil) == nil else { return }
        self.dismiss(animated: true)
    }
}

extension FindRoomViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchRequestWorkItem?.cancel()
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.viewModel?.fetch(name: searchText)
        }
        self.searchRequestWorkItem = requestWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2, execute: requestWorkItem)
    }
}

extension FindRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRoom = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        self.roomTransferDelegate?.transfer(room: selectedRoom)
        self.dismiss(animated: true)
    }
}

private extension FindRoomViewController {
    func configure() {
        self.configureContainerViewLayout()
        self.configureSearchBarLayout()
        self.configureRoomListTableViewLayout()
        self.configureRoomListTableView()
        self.bindViewModel()
        self.configureDelegates()
        self.configureTapGesture()
        self.view.backgroundColor = .clear
        self.searchBar.becomeFirstResponder()
    }

    func configureContainerViewLayout() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.containerView)
        NSLayoutConstraint.activate([
            self.containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.85),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureSearchBarLayout() {
        self.searchBar.setTextFieldColor(color: .white)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: Constant.verticalSpace),
            self.searchBar.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.searchBar.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.85)
        ])
    }

    func configureRoomListTableViewLayout() {
        self.roomListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.roomListTableView)
        NSLayoutConstraint.activate([
            self.roomListTableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: Constant.verticalSpace),
            self.roomListTableView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            self.roomListTableView.leadingAnchor.constraint(equalTo: self.searchBar.leadingAnchor),
            self.roomListTableView.trailingAnchor.constraint(equalTo: self.searchBar.trailingAnchor)
        ])
    }

    func configureRoomListTableView() {
        self.roomListTableView.register(FindRoomTableViewCell.self, forCellReuseIdentifier: FindRoomTableViewCell.identifier)
        self.dataSource = UITableViewDiffableDataSource<Section, Room>(tableView: self.roomListTableView) { (_: UITableView, _: IndexPath, room: Room) -> UITableViewCell? in
            let cell = self.roomListTableView.dequeueReusableCell(withIdentifier: FindRoomTableViewCell.identifier) as? FindRoomTableViewCell
            cell?.update(room)
            return cell
        }
    }

    func bindViewModel() {
        self.viewModel?.rooms.observe(on: self) { [weak self] roomList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Room>()
            snapshot.appendSections([Section.main])
            snapshot.appendItems(roomList)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
        }
        self.viewModel?.fetch(name: "")
    }

    func configureDelegates() {
        self.searchBar.delegate = self
        self.roomListTableView.delegate = self
    }

    func configureTapGesture() {
        let clearViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clearViewTapped))
        clearViewTapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(clearViewTapGesture)
        self.view.isUserInteractionEnabled = true
    }
}
