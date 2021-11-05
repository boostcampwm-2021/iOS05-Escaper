//
//  DesignSystem.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/05.
//

import Foundation
import UIKit

enum DesignSystem {
    enum Label {
        static func h01B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 24)
            return label
        }

        static func h02B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 22)
            return label
        }

        static func h03B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }

        static func b01B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 14)
            return label
        }

        static func b02B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 12)
            return label
        }

        static func b03B(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.boldSystemFont(ofSize: 10)
            return label
        }

        static func b01R(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.systemFont(ofSize: 14)
            return label
        }

        static func b02R(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.systemFont(ofSize: 12)
            return label
        }

        static func b03R(text: String = "", color: Color) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textColor = color.asset
            label.font = UIFont.systemFont(ofSize: 10)
            return label
        }
    }

    enum Color {
        case bloodyBlack
        case bloodyBurgundy
        case bloodyDarkBurgundy
        case bloodyRed
        case charcoal
        case gloomyPink
        case gloomyPurple
        case gloomyRed
        case gloomyBrown
        case pumpkin
        case skullLightWhite
        case skullWhite

        var asset: UIColor? {
            return UIColor(named: String(describing: self))
        }
    }
}
