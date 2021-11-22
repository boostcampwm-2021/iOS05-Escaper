//
//  MapViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit
import MapKit

final class MapViewController: DefaultViewController {
    private var locationManager: CLLocationManager?
    private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.isRotateEnabled = false
        mapView.tintColor = .purple
        return mapView
    }()
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "탈출할 카페를 찾아보세요!"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .clear
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addBottomSheetView()
    }

    func create() {
        // 의존성 주입
    }

    func addBottomSheetView() {
        let storeListViewController = StoreListViewController()
        self.addChild(storeListViewController)
        self.view.addSubview(storeListViewController.view)
        storeListViewController.didMove(toParent: self)
        storeListViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY,
                                                    width: self.view.frame.width,
                                                    height: self.view.frame.height)
    }
}

private extension MapViewController {
    func configure() {
        self.configureMapViewLayout()
        self.configureSearchBarLayout()
        self.configureLocationManager()
        self.configureCurrentLocationInMapView()
    }

    func configureMapViewLayout() {
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }

    func configureSearchBarLayout() {
        self.searchBar.setTextFieldColor(color: .white)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85)
        ])
    }

    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }

    func configureCurrentLocationInMapView() {
        guard let manager = self.locationManager,
              let currentLocation = manager.location else { return }
        let regionRadius: CLLocationDistance = 1000.0
        let region = MKCoordinateRegion(center: currentLocation.coordinate,
                                        latitudinalMeters: regionRadius,
                                        longitudinalMeters: regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
}
