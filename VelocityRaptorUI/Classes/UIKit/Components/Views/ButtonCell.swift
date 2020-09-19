//
//  ButtonCell.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import Reusable
import VelocityRaptorCore

public protocol ButtonCellDelegate: class {
    func buttonCell(didTap cell: ButtonCell)
}

public class ButtonCell: UITableViewCell, Reusable {

    let primaryButton = BetterButton.primary()
    let outlineButton = BetterButton.primaryOutlined()

    weak var delegate: ButtonCellDelegate?

    var viewModel: ButtonViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }

            primaryButton.isHidden = true
            outlineButton.isHidden = true

            if viewModel.isPrimary {
                primaryButton.isHidden = false
                primaryButton.setTitle(viewModel.title.localizedUppercase, for: .normal)
            }
            else {
                outlineButton.isHidden = false
                outlineButton.setTitle(viewModel.title.localizedUppercase, for: .normal)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        contentView.backgroundColor = .clear
        backgroundColor = .clear

        contentView.preservesSuperviewLayoutMargins = true
        preservesSuperviewLayoutMargins = true

        contentView.addSubview(primaryButton)
        primaryButton.horizontalAnchors == contentView.layoutMarginsGuide.horizontalAnchors
        primaryButton.verticalAnchors == contentView.verticalAnchors + VRC.padding2
        primaryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        contentView.addSubview(outlineButton)
        outlineButton.horizontalAnchors == contentView.layoutMarginsGuide.horizontalAnchors
        outlineButton.verticalAnchors == contentView.verticalAnchors + VRC.padding2
        outlineButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: 0)
    }

    @objc func buttonTapped() {
        delegate?.buttonCell(didTap: self)
    }

}

public struct ButtonViewModel: TableViewCellRepresentable {
    let id: String
    let title: String
    let isPrimary: Bool

    init(id: String, title: String, isPrimary: Bool = true) {
        self.id = id
        self.title = title
        self.isPrimary = isPrimary
    }

    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ButtonCell.self)
        cell.viewModel = self
        return cell
    }
}
