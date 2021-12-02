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

final class MapViewController: DefaultDIViewController<MapViewModelInterface> {
    private weak var delegate: StoreListDelegate?
    private weak var childViewController: StoreListViewController?
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
        searchBar.backgroundImage = UIImage()
        searchBar.isTranslucent = true
        searchBar.searchTextField.backgroundColor = EDSColor.skullLightWhite.value
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return searchBar
    }()
    private let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(EDSSystemImage.location.value, for: .normal)
        button.tintColor = .purple
        button.backgroundColor = EDSColor.skullLightWhite.value
        button.layer.cornerRadius = 10
        return button
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

    func addBottomSheetView() {
        let storeListViewController = StoreListViewController()
        self.childViewController = storeListViewController
        self.addChild(storeListViewController)
        self.view.addSubview(storeListViewController.view)
        self.delegate = storeListViewController
        storeListViewController.didMove(toParent: self)
        storeListViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY,
                                                    width: self.view.frame.width, height: self.view.frame.height)
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

    @objc func currentButtonTouched() {
        guard let currentLocation = locationManager?.location else { return }
        self.mapView.setCenter(currentLocation.coordinate, animated: true)
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        guard self.childViewController != nil else { return }
        self.removeBottomSheetView()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard self.childViewController != nil else { return }
        self.removeBottomSheetView()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let storeName = searchBar.searchTextField.text else { return }
        self.viewModel.query(name: storeName)
        self.searchBar.endEditing(true)
        guard self.childViewController == nil else { return }
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.addBottomSheetView()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        let reuseIdentifier = "StoreAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = EDSImage.keyMarker.value
        return annotationView
    }

    func mapView(_ mapVopiew: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? StoreAnnotation,
              !annotation.isKind(of: MKUserLocation.self) else { return }
        view.isSelected = false
        let repository = RoomListRepository(service: FirebaseService.shared)
        let usecase = RoomListUseCase(repository: repository)
        let viewModel = StoreDetailViewModel(usecase: usecase)
        let storeDetailViewController = StoreDetailViewController(viewModel: viewModel)
        storeDetailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(storeDetailViewController, animated: true)
    }
}

private extension MapViewController {
    func configure() {
        self.configureMapViewLayout()
        self.configureSearchBarLayout()
        self.configureCurrentLocationButtonLayout()
        self.configureLocationManager()
        self.configureCurrentLocationInMapView()
        self.configureDelegates()
        self.bindViewModel()
        self.configureTapGesture()
        self.configureCurrentButtonTarget()
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
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.searchBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7),
            self.searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureCurrentLocationButtonLayout() {
        self.currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.currentLocationButton)
        NSLayoutConstraint.activate([
            self.currentLocationButton.centerYAnchor.constraint(equalTo: self.searchBar.centerYAnchor),
            self.currentLocationButton.widthAnchor.constraint(equalTo: self.searchBar.heightAnchor),
            self.currentLocationButton.heightAnchor.constraint(equalTo: self.currentLocationButton.widthAnchor),
            self.currentLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10)
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
        self.mapView.delegate = self
    }

    func bindViewModel() {
        self.viewModel.stores.observe(on: self, observerBlock: { [weak self] stores in
            self?.delegate?.transfer(stores)
            self?.mapView.addAnnotations(stores.map { StoreAnnotation(store: $0) })
            guard let nearestStore = stores.first else { return }
            self?.mapView.setCenter(nearestStore.geoLocation.coordinate, animated: true)
        })
    }

    func configureTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.mapViewTapped))
        self.mapView.addGestureRecognizer(gesture)
    }

    func configureCurrentButtonTarget() {
        self.currentLocationButton.addTarget(self, action: #selector(self.currentButtonTouched), for: .touchUpInside)
    }
}
