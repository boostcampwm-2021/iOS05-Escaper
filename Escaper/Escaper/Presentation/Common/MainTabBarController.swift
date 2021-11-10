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
        self.configureTabBar()
        self.configureSubViewControllers()
    }
}

private extension MainTabBarController {
    enum TabBarItemConfig: String {
        var title: String {
            return self.rawValue
        }
        var unselectedImage: UIImage? {
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
            unselected: TabBarItemConfig.home.unselectedImage,
            selected: TabBarItemConfig.home.selectedImage
        )
        let homeViewController = RoomListViewController()
        homeViewController.tabBarItem = homeBarItem
        homeViewController.create()

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

        let leaderBoardBarItem = self.makeTabBarItem(
            title: TabBarItemConfig.leaderBoard.title,
            unselected: TabBarItemConfig.leaderBoard.unselectedImage,
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