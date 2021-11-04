//
//  RoomListViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/10/31.
//

import UIKit

final class RoomListViewController: DefaultViewController {

    enum Constant {
        static let tagViewHeight = CGFloat(35)
    }

    private var viewModel: RoomListViewModelInterface!

    private var genreTagScrollView: TagScrollView = {
        let tagScrollView: TagScrollView = TagScrollView()
        tagScrollView.showsHorizontalScrollIndicator = false
        return tagScrollView
    }()

    private var sortingOptionTagScrollView: TagScrollView = {
        let tagScrollView: TagScrollView = TagScrollView()
        tagScrollView.showsHorizontalScrollIndicator = false
        return tagScrollView
    }()

    func create() {
//        let repository = DefaultNetworkService()
//        let useCase = DefaultRoomListUseCase(repository: repository)
//        let viewModel = DefaultRoomListViewModel(usecase: useCase)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureGenreTagScrollView()
        self.configureSortingOptionTagScrollView()
    }

    private func configureGenreTagScrollView() {
        self.genreTagScrollView.tagDelegate = self
        self.genreTagScrollView.inject(elements: Genre.allCases)

        self.genreTagScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.genreTagScrollView)
        NSLayoutConstraint.activate([
            self.genreTagScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.genreTagScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.genreTagScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.genreTagScrollView.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }

    private func configureSortingOptionTagScrollView() {
        self.sortingOptionTagScrollView.tagDelegate = self
        self.sortingOptionTagScrollView.inject(elements: SortingOption.allCases)

        self.sortingOptionTagScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.sortingOptionTagScrollView)
        NSLayoutConstraint.activate([
            self.sortingOptionTagScrollView.topAnchor.constraint(equalTo: self.genreTagScrollView.bottomAnchor, constant: 10),
            self.sortingOptionTagScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.sortingOptionTagScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.sortingOptionTagScrollView.heightAnchor.constraint(equalToConstant: Constant.tagViewHeight)
        ])
    }
}

extension RoomListViewController: TagScrollViewDelegate {
    func tagSelected(element: Tagable) {
        print(element.name)
    }

}
