//
//  DistrictSelectView.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

protocol DistrictSelectViewDelegate: AnyObject {
    func districtDidSelected(district: District)
}

class DistrictSelectButton: UIButton {
    weak var delegate: DistrictSelectViewDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.makeMenu()
        }
        return configuration
    }

    func updateTitle(district: District) {
        self.setTitle(" \(district.name) 기준 ", for: .normal)
    }
}

private extension DistrictSelectButton {
    func configure() {
        self.backgroundColor = EDSColor.bloodyBlack.value
        self.semanticContentAttribute = .forceRightToLeft
        self.setTitle(" 지역 선택 ", for: .normal)
        self.setTitleColor(EDSColor.pumpkin.value, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.setImage(EDSImage.chevronDown.value, for: .normal)
        if #available(iOS 14.0, *) {
            self.showsMenuAsPrimaryAction = true
            self.menu = self.makeMenu()
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            self.addInteraction(interaction)
        }
    }

    func makeMenu() -> UIMenu {
        let districtActions = District.allCases.map { district in
            UIAction(title: district.name) { [weak self] _ in
                self?.delegate?.districtDidSelected(district: district)
                self?.updateTitle(district: district)
            }
        }
        return UIMenu(title: "", children: districtActions)
    }
}
