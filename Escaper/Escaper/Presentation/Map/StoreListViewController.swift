//
//  StoreListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/21.
//

import UIKit
import CoreLocation

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
    let minimumTopSpacing: CGFloat = 120
    var maximumTopSpacing: CGFloat {
        return UIScreen.main.bounds.height * 0.7
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            guard let self = self else { return }
            let frame = self.view.frame
            let yComponent = self.maximumTopSpacing
            self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height - 100)
        })
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

    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let positionY = self.view.frame.minY
        if (positionY + translation.y >= minimumTopSpacing) && (positionY + translation.y <= maximumTopSpacing) {
            self.view.frame = CGRect(x: 0, y: positionY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }

        guard recognizer.state == .ended else { return }
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.allowUserInteraction], animations: {
            if  velocity.y >= 0 {
                self.view.frame = CGRect(x: 0, y: self.maximumTopSpacing, width: self.view.frame.width, height: self.view.frame.height)
            } else {
                self.view.frame = CGRect(x: 0, y: self.minimumTopSpacing, width: self.view.frame.width, height: self.view.frame.height)
            }
        }, completion: { [weak self] _ in
            guard velocity.y < 0 else { return }
            self?.storeListTableView.isScrollEnabled = true
        })
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
        self.mockInjection()
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
        self.storeListTableView.register(StoreOverViewTableViewCell.self, forCellReuseIdentifier: StoreOverViewTableViewCell.identifier)
        self.dataSource = UITableViewDiffableDataSource<Section, Store>(tableView: self.storeListTableView) { (tableView, _, store) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: StoreOverViewTableViewCell.identifier) as? StoreOverViewTableViewCell
            cell?.update(store)
            return cell
        }
    }

    func mockInjection() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Store>()
        let mockStores = [Store(name: "이스케이프 룸 강남점", homePage: "", telephone: "", address: "", region: .gangnam,
                            geoLocation: CLLocation(), district: .gangnamgu, roomIds: ["", "", "", ""]),
                      Store(name: "키이스케이프 강남점", homePage: "", telephone: "", address: "", region: .gangnam,
                                          geoLocation: CLLocation(), district: .gangnamgu, roomIds: ["", "", ""])
        ]
        snapshot.appendSections([Section.main])
        snapshot.appendItems(mockStores)
        self.dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
