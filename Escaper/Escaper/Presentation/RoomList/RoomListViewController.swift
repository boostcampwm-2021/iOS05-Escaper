//
//  RoomListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit

class RoomListViewController: UIViewController {
    
    private var viewModel: RoomListViewModelInterface!
    
    func create() {
//        let repository = DefaultNetworkService()
//        let useCase = DefaultRoomListUseCase(repository: repository)
//        let viewModel = DefaultRoomListViewModel(usecase: useCase)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
    }

}
