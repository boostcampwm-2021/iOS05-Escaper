//
//  MainTabBarController.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

class MainTabBarController: UITabBarController {
    enum Constant {
        static let itemInset = CGFloat(10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSubViewControllers()
        self.configureTabBar()
    }
}

private extension MainTabBarController {
    enum TabBarItemConfig: String {
        var title: String {
            return self.rawValue
        }
        var image: UIImage? {
            return UIImage(named: String(describing: self))
        }
        var selectedImage: UIImage? {
            return UIImage(named: String(describing: self) + "Selected")
        }

        case home = "홈"
        case record = "기록"
        case map = "지도"
        case leaderBoard = "리더보드"
    }

    func configureTabBar() {
        let homeBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.home.title,
            image: TabBarItemConfig.home.image,
            selected: TabBarItemConfig.home.selectedImage
        )
        let homeViewController = RoomListViewController()
        homeViewController.tabBarItem = homeBarItem
        homeViewController.create()

        let recordBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.record.title,
            image: TabBarItemConfig.record.image,
            selected: TabBarItemConfig.record.selectedImage
        )
        let recordViewController = RecordViewController()
        recordViewController.tabBarItem = recordBarItem
        recordViewController.create()

        let mapBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.map.title,
            image: TabBarItemConfig.map.image,
            selected: TabBarItemConfig.map.selectedImage
        )
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = mapBarItem
        mapViewController.create()

        let leaderBoardBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.leaderBoard.title,
            image: TabBarItemConfig.leaderBoard.image,
            selected: TabBarItemConfig.leaderBoard.selectedImage
        )
        let leaderBoardViewController = LeaderBoardViewController()
        leaderBoardViewController.tabBarItem = leaderBoardBarItem
        leaderBoardViewController.create()

        let viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            recordViewController,
            mapViewController,
            leaderBoardViewController
        ]
        self.viewControllers = viewControllers
    }

    func configureSubViewControllers() {
        self.tabBar.backgroundColor = EDSKit.Color.gloomyBrown.value
        self.tabBar.tintColor = EDSKit.Color.skullLightWhite.value
        self.tabBar.barTintColor = EDSKit.Color.skullLightWhite.value
    }

    func makeTabBarItem(title: String, image: UIImage?, selected: UIImage?) -> UITabBarItem {
        let item = UITabBarItem(
            title: title,
            image: image,
            selectedImage: selected
        )
        return item
    }
}
