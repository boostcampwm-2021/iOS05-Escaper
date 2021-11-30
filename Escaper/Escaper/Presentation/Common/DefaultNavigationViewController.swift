//
//  DefaultNavigationViewController.swift
//  Escaper
//
//  Created by 박영광 on 2021/11/30.
//

import UIKit

final class DefaultNavigationViewController: UINavigationController {
    private let navigationAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = .none
        appearance.shadowColor = .clear
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
}

private extension DefaultNavigationViewController {
    func configure() {
        self.navigationBar.standardAppearance = self.navigationAppearance
        self.navigationBar.scrollEdgeAppearance = self.navigationAppearance
        self.navigationBar.tintColor = EDSColor.skullLightWhite.value
        self.navigationBar.topItem?.title = ""
    }
}
