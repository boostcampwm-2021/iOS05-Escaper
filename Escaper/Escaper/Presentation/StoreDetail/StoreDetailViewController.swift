//
//  StoreDetailViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/22.
//

import UIKit
import CoreLocation

class StoreDetailViewController: DefaultViewController {
    let mock = Store(name: "이스케이프 룸 강남점", homePage: "http://www.mysteryroomescape-gn.com/", telephone: "02-536-2564", address: "서울 서초구 서초동 1308-10", region: .gangnam, geoLocation: CLLocation(latitude: CLLocationDegrees(CGFloat(37.498095)), longitude: CLLocationDegrees(CGFloat(127.027610))), district: .seochogu, roomIds: ["2001", "2002", "2003", "2004"])

    var store: Store?
    private var storeTitleLabel: UILabel = EDSLabel.h01B(color: .pumpkin)
    private var infoDescriptionStackView: InfoDescriptionStackView = InfoDescriptionStackView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.create(store: mock) // TODO: - 외부 주입

        self.configure()
        self.inject(store: mock)
    }

    func create(store: Store) {
        self.store = store
        // TODO: - dependency Injection
    }
}

private extension StoreDetailViewController {
    enum Constant {
        static let sideSpace = CGFloat(20)
        static let topSpace = CGFloat(10)
    }

    func configure() {
        self.configureStoreTitleLabelLayout()
        self.configureInfoDescriptionStackViewLayout()
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

    func inject(store: Store) {
        self.storeTitleLabel.text = store.name
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "위치", content: store.region.krName))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "테마 개수", content: "\(store.roomIds.count)개"))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "거리", content: "100m"))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "전화번호", content: store.telephone))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "주소", content: store.address))
        self.infoDescriptionStackView.inject(view: InfoDescriptionDetailStackView(title: "홈페이지", content: store.homePage))
    }
}
