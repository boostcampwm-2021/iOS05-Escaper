//
//  DistrictSelectButton.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/09.
//

import UIKit

protocol DistrictSelectViewDelegate: AnyObject {
    func districtDidSelected(district: District)
}

final class DistrictSelectButton: UIButton {
    weak var delegate: DistrictSelectViewDelegate?

    private var districtLabel: UILabel = {
        let label = EDSLabel.b01B(text: "         지역 ", color: .pumpkin)
        label.textAlignment = .center
        return label
    }()
    private var infoLabel: UILabel = {
        let label = EDSLabel.b01B(text: "선택 ", color: .pumpkin)
        label.textAlignment = .right
        return label
    }()
    private var indicatorImageView = UIImageView(image: EDSImage.chevronDown.value)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            return self?.makeMenu()
        }
        return configuration
    }

    func updateTitle(district: District) {
        self.districtLabel.text = " \(district.name) "
        self.infoLabel.text = "기준 "
    }
}

private extension DistrictSelectButton {
    enum Constant {
        static let sideSpace = CGFloat(5)
        static let districtLabelWidth = CGFloat(61)
        static let infoLabelWidth = CGFloat(25)
        static let imageLength = CGFloat(14)
    }

    func configure() {
        self.configureUI()
        self.configureIndicatorImageViewLayout()
        self.configureDistrictLayout()
        self.configureInfoLabelLayout()
    }

    func configureUI() {
        self.backgroundColor = EDSColor.bloodyBlack.value
        if #available(iOS 14.0, *) {
            self.showsMenuAsPrimaryAction = true
            self.menu = self.makeMenu()
        } else {
            let interaction = UIContextMenuInteraction(delegate: self)
            self.addInteraction(interaction)
        }
    }

    func configureDistrictLayout() {
        self.districtLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.districtLabel)
        NSLayoutConstraint.activate([
            self.districtLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.districtLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.districtLabel.widthAnchor.constraint(equalToConstant: Constant.districtLabelWidth)
        ])
    }

    func configureInfoLabelLayout() {
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.infoLabel)
        NSLayoutConstraint.activate([
            self.infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.indicatorImageView.leadingAnchor, constant: -Constant.sideSpace),
            self.infoLabel.widthAnchor.constraint(equalToConstant: Constant.infoLabelWidth)
        ])
    }

    func configureIndicatorImageViewLayout() {
        self.indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.indicatorImageView)
        NSLayoutConstraint.activate([
            self.indicatorImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.indicatorImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.indicatorImageView.widthAnchor.constraint(equalToConstant: Constant.imageLength),
            self.indicatorImageView.heightAnchor.constraint(equalToConstant: Constant.imageLength)
        ])
    }

    func makeMenu() -> UIMenu {
        let possibleDistricts = District.allCases.dropLast()
        let districtActions = possibleDistricts.map { district in
            UIAction(title: district.name) { [weak self] _ in
                self?.delegate?.districtDidSelected(district: district)
                self?.updateTitle(district: district)
            }
        }
        return UIMenu(title: "", children: districtActions)
    }
}
