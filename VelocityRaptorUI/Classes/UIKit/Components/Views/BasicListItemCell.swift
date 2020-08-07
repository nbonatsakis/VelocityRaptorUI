//
//  BasicListItemCell.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import Then
import Reusable

public class BasicListItemCell: UITableViewCell, Reusable {

    var viewModel: BasicListItemViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            textLabel?.text = viewModel.text

            accessoryType = .none
            accessoryView = nil
            selectionStyle = viewModel.isSelectable ? .default : .none

            switch viewModel.accessoryType {
            case .none:
                accessoryType = .none
            case .disclosure:
                accessoryType = .disclosureIndicator
            case .text(let text):
                let label = UILabel().then {
                    $0.text = text
                    $0.font = .preferredFont(for: .headline, weight: .bold)
                    $0.textColor = .secondaryLabel
                }
                label.sizeToFit()
                accessoryView = label
            case .custom(let image):
                accessoryView = UIImageView(image: image)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public struct BasicListItemViewModel: Hashable, TableViewCellRepresentable {

    public enum AccessoryType: Equatable {

        case none
        case disclosure
        case text(String)
        case custom(UIImage)

    }

    let text: String
    let isSelectable: Bool
    let accessoryType: AccessoryType
    let action: VoidClosure

    init(
        text: String,
        isSelectable: Bool = true,
        accessoryType: AccessoryType,
        action: @escaping VoidClosure) {
        self.text = text
        self.isSelectable = isSelectable
        self.accessoryType = accessoryType
        self.action = action
    }

    public static func == (lhs: BasicListItemViewModel, rhs: BasicListItemViewModel) -> Bool {
        return lhs.text == rhs.text &&
                lhs.accessoryType == rhs.accessoryType
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BasicListItemCell.self)
        cell.viewModel = self
        return cell
    }

}
