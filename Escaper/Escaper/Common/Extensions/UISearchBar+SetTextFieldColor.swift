//
//  UISearchBar+SetTextFieldColor.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/13.
//

import UIKit

extension UISearchBar {
    func setTextFieldColor(color: UIColor?) {
        guard let textField = self.value(forKey: "searchField") as? UITextField else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color?.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
