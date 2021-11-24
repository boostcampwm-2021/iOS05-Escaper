//
//  MainTabBarController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

final class MainTabBarController: UITabBarController {
    enum Constant {
        static let itemInset = CGFloat(10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabBar()
        self.configureSubViewControllers()
    }
}

private extension MainTabBarController {
    enum TabBarItemConfig: String {
        case home = "홈"
        case record = "기록"
        case map = "지도"
        case leaderBoard = "리더보드"

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

    func configureTabBar() {
        let homeBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.home.title,
            unselected: TabBarItemConfig.home.unselectedImage,
            selected: TabBarItemConfig.home.selectedImage
        )
        let homeViewController = RoomListViewController()
        homeViewController.tabBarItem = homeBarItem
        homeViewController.create()
        let homeNavigationController: UINavigationController = {
            let navigationController = UINavigationController(rootViewController: homeViewController)
            let navigationAppearance: UINavigationBarAppearance = {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = EDSColor.bloodyBlack.value
                return appearance
            }()
            navigationController.navigationBar.standardAppearance = navigationAppearance
            navigationController.navigationBar.tintColor = EDSColor.skullLightWhite.value
            navigationController.navigationBar.topItem?.title = ""
            if #available(iOS 15.0, *) {
                navigationController.navigationBar.compactScrollEdgeAppearance = navigationAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
            }
            return navigationController
        }()
        let recordBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.record.title,
            unselected: TabBarItemConfig.record.unselectedImage,
            selected: TabBarItemConfig.record.selectedImage
        )
        let recordViewController = RecordViewController()
        recordViewController.tabBarItem = recordBarItem
        recordViewController.create()
        let mapBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.map.title,
            unselected: TabBarItemConfig.map.unselectedImage,
            selected: TabBarItemConfig.map.selectedImage
        )
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = mapBarItem
        mapViewController.create()

        let mapNavigationController: UINavigationController = {
            let navigationController = UINavigationController(rootViewController: mapViewController)
            let navigationAppearance: UINavigationBarAppearance = {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = EDSColor.bloodyBlack.value
                return appearance
            }()
            navigationController.navigationBar.standardAppearance = navigationAppearance
            navigationController.navigationBar.tintColor = EDSColor.skullLightWhite.value
            navigationController.navigationBar.topItem?.title = ""
            if #available(iOS 15.0, *) {
                navigationController.navigationBar.compactScrollEdgeAppearance = navigationAppearance
                navigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
            }
            return navigationController
        }()
        let leaderBoardBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.leaderBoard.title,
            unselected: TabBarItemConfig.leaderBoard.unselectedImage,
            selected: TabBarItemConfig.leaderBoard.selectedImage
        )
        let leaderBoardViewController = LeaderBoardViewController()
        leaderBoardViewController.tabBarItem = leaderBoardBarItem
        leaderBoardViewController.create()
        let viewControllers = [
            homeNavigationController,
            recordViewController,
            mapNavigationController,
            leaderBoardViewController
        ]
        self.viewControllers = viewControllers
    }

    func configureSubViewControllers() {
        let tabBarAppearance: UITabBarAppearance = {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = EDSColor.gloomyBrown.value
            return appearance
        }()
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.backgroundColor = EDSColor.gloomyBrown.value
        self.tabBar.tintColor = EDSColor.skullLightWhite.value
        self.tabBar.barTintColor = EDSColor.skullLightWhite.value
    }

    func makeTabBarItem(title: String, unselected: UIImage?, selected: UIImage?) -> UITabBarItem {
        let item = UITabBarItem(
            title: title,
            image: unselected,
            selectedImage: selected
        )
        item.imageInsets = UIEdgeInsets(top: Constant.itemInset, left: Constant.itemInset, bottom: Constant.itemInset, right: Constant.itemInset)
        return item
    }
}
