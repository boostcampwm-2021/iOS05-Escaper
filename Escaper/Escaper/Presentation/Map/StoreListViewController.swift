//
//  StoreListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/21.
//

import UIKit

class StoreListViewController: DefaultViewController {
    private var dataSource: UITableViewDiffableDataSource<Section, Store>?
    private let grabberView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.backgroundColor = EDSColor.skullLightWhite.value
        return view
    }()
    private let storeListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = 100
        return tableView
    }()
    private var emptyResultView: EmptyResultView = {
        let emptyResultView = EmptyResultView()
        emptyResultView.injectContentLabelText(text: "검색 결과가 없어요. 다른 업체를 검색해주세요.")
        emptyResultView.alpha = 0.5
        return emptyResultView
    }()
    var minimumTopSpacing: CGFloat {
        return UIScreen.main.bounds.height * 0.15
    }
    var maximumTopSpacing: CGFloat {
        return UIScreen.main.bounds.height * 0.6
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }

    @objc func viewMoveGesutre(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let positionY = self.view.frame.minY
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
        if (positionY + translation.y >= minimumTopSpacing) && (positionY + translation.y <= maximumTopSpacing) {
            self.view.frame = CGRect(x: 0, y: positionY + translation.y, width: self.view.frame.width, height: UIScreen.main.bounds.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        guard recognizer.state == .ended else { return }
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.allowUserInteraction], animations: {
            if  velocity.y >= 0 {
                self.view.frame = CGRect(x: 0, y: self.maximumTopSpacing, width: self.view.frame.width, height: UIScreen.main.bounds.height)
            } else {
                self.view.frame = CGRect(x: 0, y: self.minimumTopSpacing, width: self.view.frame.width, height: UIScreen.main.bounds.height)
            }
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            let yComponent = velocity.y >= 0 ? self.maximumTopSpacing : self.minimumTopSpacing
            let height = UIScreen.main.bounds.height - yComponent - tabBarHeight
            self.view.frame = CGRect(x: 0, y: yComponent, width: self.view.frame.width, height: height)
        })
    }
}

extension StoreListViewController: StoreListDelegate {
    func transfer(_ stores: [Store]) {
        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
        let yComponent = stores.isEmpty ? self.minimumTopSpacing : self.maximumTopSpacing
        let height = UIScreen.main.bounds.height - yComponent - tabBarHeight
        self.emptyResultView.isHidden = stores.isNotEmpty
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            guard let self = self else { return }
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: height)
        })
        self.updateDataSource(stores: stores)
    }
}

extension StoreListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedStore = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let repository = RoomListRepository(service: FirebaseService.shared)
        let usecase = RoomListUseCase(repository: repository)
        let viewModel = StoreDetailViewModel(usecase: usecase)
        let storeDetailViewController = StoreDetailViewController(viewModel: viewModel)
        storeDetailViewController.create(store: selectedStore, viewModel: viewModel)
        storeDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(storeDetailViewController, animated: true)
    }
}

private extension StoreListViewController {
    enum Section {
        case main
    }

    func configure() {
        self.configureGabberViewLayout()
        self.configureStoreListTableViewLayout()
        self.configureStoreListTableView()
        self.configureEmptyResultViewLayout()
        self.configureViewMoverGesture()
    }

    func configureGabberViewLayout() {
        self.grabberView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.grabberView)
        NSLayoutConstraint.activate([
            self.grabberView.widthAnchor.constraint(equalToConstant: 60),
            self.grabberView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.grabberView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            self.grabberView.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    func configureStoreListTableViewLayout() {
        self.storeListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.storeListTableView)
        NSLayoutConstraint.activate([
            self.storeListTableView.topAnchor.constraint(equalTo: self.grabberView.bottomAnchor, constant: 20),
            self.storeListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.storeListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.storeListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureStoreListTableView() {
        self.storeListTableView.delegate = self
        self.storeListTableView.register(StoreOverViewTableViewCell.self, forCellReuseIdentifier: StoreOverViewTableViewCell.identifier)
        self.dataSource = UITableViewDiffableDataSource<Section, Store>(tableView: self.storeListTableView) { (tableView, _, store) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreOverViewTableViewCell.identifier) as? StoreOverViewTableViewCell
            cell?.update(store)
            return cell
        }
    }

    func configureEmptyResultViewLayout() {
        self.emptyResultView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.emptyResultView)
        NSLayoutConstraint.activate([
            self.emptyResultView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emptyResultView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.emptyResultView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            self.emptyResultView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.25)
        ])
    }

    func configureViewMoverGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.viewMoveGesutre(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    func updateDataSource(stores: [Store]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Store>()
        snapShot.appendSections([.main])
        snapShot.appendItems(stores)
        self.dataSource?.apply(snapShot, animatingDifferences: true)
    }
}
