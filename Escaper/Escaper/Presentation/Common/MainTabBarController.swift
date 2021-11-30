//
//  MainTabBarController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit
import AVFoundation

final class MainTabBarController: UITabBarController {
    internal enum TabBarItemConfig: String {
        case home = "홈"
        case record = "기록"
        case map = "지도"
        case leaderBoard = "리더보드"
        case setting = "설정"

        var title: String {
            return self.rawValue
        }
        var unselectedImage: UIImage? {
            return UIImage(named: String(describing: self))
        }
        var selectedImage: UIImage? {
            return UIImage(named: String(describing: self) + "Selected")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegate()
        self.configure()
        self.configureTabBar()
    }
}

private extension MainTabBarController {
    func configure() {
        let homeBarItem = self.makeTabBarItem(config: .home)
        let homeViewController = RoomListViewController()
        homeViewController.create()
        let homeNavigationController = DefaultNavigationViewController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = homeBarItem

        let recordBarItem = self.makeTabBarItem(config: .record)
        let recordViewController = RecordViewController()
        recordViewController.create()
        recordViewController.tabBarItem = recordBarItem

        let mapBarItem = self.makeTabBarItem(config: .map)
        let mapViewController = MapViewController()
        mapViewController.create()
        let mapNavigationController = DefaultNavigationViewController(rootViewController: mapViewController)
        mapNavigationController.tabBarItem = mapBarItem

        let leaderBoardBarItem = self.makeTabBarItem(config: .leaderBoard)
        let leaderBoardViewController = LeaderBoardViewController()
        leaderBoardViewController.create()
        leaderBoardViewController.tabBarItem = leaderBoardBarItem

        let settingBarItem = self.makeTabBarItem(config: .setting)
        let settingViewController = SettingViewController()
        settingViewController.create()
        settingViewController.tabBarItem = settingBarItem

        let viewControllers = [
            homeNavigationController,
            recordViewController,
            mapNavigationController,
            leaderBoardViewController,
            settingViewController
        ]
        self.viewControllers = viewControllers
    }

    func configureTabBar() {
        let tabBarAppearance: UITabBarAppearance = {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = EDSColor.gloomyLightBrown.value
            return appearance
        }()
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.backgroundColor = EDSColor.gloomyLightBrown.value
        self.tabBar.tintColor = EDSColor.skullLightWhite.value
        self.tabBar.barTintColor = EDSColor.skullLightWhite.value
    }

    func makeTabBarItem(config: TabBarItemConfig) -> UITabBarItem {
        let item = UITabBarItem(
            title: config.title,
            image: config.unselectedImage,
            selectedImage: config.selectedImage
        )
        item.imageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return item
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    private func configureDelegate() {
        self.delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
