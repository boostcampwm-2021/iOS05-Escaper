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
        let viewController = MainTabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}
