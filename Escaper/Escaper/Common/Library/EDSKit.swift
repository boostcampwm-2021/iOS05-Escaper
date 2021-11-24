//
//  DesignSystem.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/05.
//

import UIKit

typealias EDSColor = EDSKit.Color
typealias EDSLabel = EDSKit.Label
typealias EDSImage = EDSKit.Image

enum EDSKit {
    enum Label {
        static func h01B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            return label
        }

        static func h02B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            return label
        }

        static func h03B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            return label
        }

        static func b01B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            return label
        }

        static func b02B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            return label
        }

        static func b03B(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            return label
        }

        static func b01R(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            return label
        }

        static func b02R(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            return label
        }

        static func b03R(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            return label
        }

        static func b01L(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 14, weight: .light)
            return label
        }

        static func b02L(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 12, weight: .light)
            return label
        }

        static func b03L(text: String = "", color: Color) -> UILabel {
            let label = Label.makeLabel(text: text, color: color)
            label.font = UIFont.systemFont(ofSize: 10, weight: .light)
            return label
        }
    }

    enum Color {
        case bloodyBlack
        case bloodyBurgundy
        case bloodyDarkBurgundy
        case bloodyRed
        case charcoal
        case gloomyBrown
        case gloomyLightBrown
        case gloomyPink
        case gloomyPurple
        case gloomyRed
        case pumpkin
        case skullGrey
        case skullLightWhite
        case skullWhite
        case zombiePurple

        var value: UIColor? {
            return UIColor(named: String(describing: self))
        }
    }

    enum Image {
        case chevronDown
        case crown
        case distanceIcon
        case emailIcon
        case eyeIcon
        case genreIcon
        case keyMarker
        case loginPumpkin
        case mappin
        case passwordIcon
        case plus
        case recordBook
        case recordCard
        case recordCandle
        case signupGhost
        case signupPlus
        case signupSkull

        var value: UIImage? {
            return self == .mappin ? UIImage(systemName: "mappin.and.ellipse") : UIImage(named: String(describing: self))
        }
    }
}

private extension EDSLabel {
    static func makeLabel(text: String, color: EDSColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color.value
        return label
    }
}
