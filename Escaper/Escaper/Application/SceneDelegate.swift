//
//  SceneDelegate.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

//        DataInjection.shared.run(storeRegion: .extra)
//        DataInjection.shared.run(storeRegion: .sinlim)
//        let viewController = MainTabBarController()
        let vc = StoreDetailViewController()
        let store = Store(name: "이스케이프 룸 강남점", homePage: "http://www.mysteryroomescape-gn.com/", telephone: "02-536-2564", address: "서울 서초구 서초동 1308-10", region: .gangnam, geoLocation: CLLocation(latitude: CLLocationDegrees(CGFloat(37.498095)), longitude: CLLocationDegrees(CGFloat(127.027610))), district: .seochogu, roomIds: ["2001", "2002", "2003", "2004"])
        vc.create(store: store)
        let viewController =  UINavigationController(rootViewController: vc)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}
