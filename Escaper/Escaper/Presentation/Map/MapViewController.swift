//
//  MapViewController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit
import MapKit

protocol StoreListDelegate: AnyObject {
    func transfer(_ stores: [Store])
}

final class MapViewController: DefaultViewController {
    private weak var delegate: StoreListDelegate?
    private weak var childViewController: StoreListViewController?
    private var viewModel: MapViewModelInterface?
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func create() {
        let storeRepository = StoreRepository(service: FirebaseService.shared)
        let usecase = StoreUseCase(repository: storeRepository)
        let viewModel = MapViewModel(usecase: usecase)
        self.viewModel = viewModel
    }

    func addBottomSheetView() {
        let storeListViewController = StoreListViewController()
        self.childViewController = storeListViewController
        self.addChild(storeListViewController)
        self.view.addSubview(storeListViewController.view)
        self.delegate = storeListViewController
        storeListViewController.didMove(toParent: self)
        storeListViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY,
                                                    width: self.view.frame.width,
                                                    height: self.view.frame.height)
    }

    func removeBottomSheetView() {
        UIView.animate(withDuration: 0.6) { [weak self] in
            guard let self = self else { return }
            self.childViewController?.view.frame = CGRect(x: 0, y: self.view.frame.height,
                                                          width: self.view.frame.width, height: self.view.frame.height)
        } completion: { _ in
            self.childViewController?.willMove(toParent: nil)
            self.childViewController?.view.removeFromSuperview()
            self.childViewController?.removeFromParent()
            self.childViewController = nil
        }
    }

    @objc func mapViewTapped() {
        self.searchBar.endEditing(true)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard self.childViewController != nil else { return }
        self.removeBottomSheetView()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let storeName = searchBar.searchTextField.text else { return }
        self.viewModel?.query(name: storeName)
        self.searchBar.endEditing(true)
        guard self.childViewController == nil else { return }
        self.addBottomSheetView()
    }
}

private extension MapViewController {
    func configure() {
        self.configureMapViewLayout()
        self.configureSearchBarLayout()
        self.configureLocationManager()
        self.configureCurrentLocationInMapView()
        self.configureDelegates()
        self.bindViewModel()
        self.configureTapGesture()
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

    func configureDelegates() {
        self.searchBar.delegate = self
    }

    func bindViewModel() {
        self.viewModel?.stores.observe(on: self, observerBlock: { [weak self] stores in
            self?.delegate?.transfer(stores)
        })
    }

    func configureTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.mapViewTapped))
        self.mapView.addGestureRecognizer(gesture)
    }
}
