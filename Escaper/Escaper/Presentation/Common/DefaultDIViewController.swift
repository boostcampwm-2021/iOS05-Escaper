//
//  DefaultDIViewController.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/12/03.
//

import UIKit

class DefaultDIViewController<T>: DefaultViewController {
    var viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, renamed: "init(viewModel:)")
    required init?(coder: NSCoder) {
        fatalError("Invalid way of decoding this ViewController")
    }
}
