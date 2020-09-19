//
//  TableViewCellRepresentable.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

public protocol TableViewCellRepresentable: Hashable {

    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell

}

public extension TableViewCellRepresentable {

    var anyRow: AnyTableRow {
        return AnyTableRow(self)
    }

}

public struct AnyTableRow: TableViewCellRepresentable {

    private let _cellForIndex: (UITableView, IndexPath) -> UITableViewCell
    private let _equals: (Any) -> Bool
    private let _hashInto: (inout Hasher) -> Void
    let value: Any

    public init<T: TableViewCellRepresentable> (_ value: T) {
        _cellForIndex = value.cell.self
        _equals = { ($0 as? T == value) }
        _hashInto = { value.hash(into: &$0) }
        self.value = value
    }

    public func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        return _cellForIndex(tableView, indexPath)
    }

    public static func == (lhs: AnyTableRow, rhs: AnyTableRow) -> Bool {
        return lhs._equals(rhs.value)
    }

    public func hash(into hasher: inout Hasher) {
        _hashInto(&hasher)
    }

}
