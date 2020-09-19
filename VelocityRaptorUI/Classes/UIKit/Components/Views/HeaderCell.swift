//
//  HeadlineCell.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import Reusable
import VelocityRaptorCore

public class HeaderCell: UITableViewCell, Reusable {

    let iconImageView = UIImageView().then {
        $0.preferredSymbolConfiguration = UIImage.SymbolConfiguration(textStyle: VRC.tableSectionHeaderTextStyle, scale: .medium)
        $0.tintColor = VRC.tableSectionHeaderColor
    }
    let label = UILabel().then {
        $0.font = .preferredFont(forTextStyle: VRC.tableSectionHeaderTextStyle)
        $0.textColor = VRC.tableSectionHeaderColor
    }

    var viewModel: HeaderViewModel? {
        didSet {
            label.text = VRC.tableSectionHeaderUppercase ? viewModel?.title.localizedUppercase : viewModel?.title
            iconImageView.image = viewModel?.image
            iconImageView.isHidden = viewModel?.image == nil
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.preservesSuperviewLayoutMargins = true
        preservesSuperviewLayoutMargins = true

        label.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [iconImageView, label])
        stack.spacing = VRC.padding1
        stack.alignment = .center
        stack.backgroundColor = .clear

        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.setContentHuggingPriority(.required, for: .vertical)
        iconImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        iconImageView.setContentCompressionResistancePriority(.required, for: .vertical)

        contentView.addSubview(stack)
        stack.horizontalAnchors == contentView.layoutMarginsGuide.horizontalAnchors
        stack.topAnchor == contentView.topAnchor + VRC.padding2
        stack.bottomAnchor == contentView.bottomAnchor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public struct HeaderViewModel: Equatable, TableViewCellRepresentable {

    let title: String
    let image: UIImage?

    init(text: String, image: UIImage?  = nil) {
        self.title = text
        self.image = image
    }

    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HeaderCell.self)
        cell.viewModel = self
        return cell
    }

}
