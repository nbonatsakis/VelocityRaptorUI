//
//  TableDataSource.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Reusable

public struct TableSection: Hashable {

    public let identifier: AnyHashable
    public let header: String?
    public let footer: String?
    public let rows: [AnyTableRow]

    public init(
        identifier: AnyHashable,
        header: String? = nil,
        footer: String? = nil,
        rows: [AnyTableRow]
    ) {
        self.identifier = identifier
        self.rows = rows
        self.header = header
        self.footer = footer
    }

    public func hash(into hasher: inout Hasher) {
        identifier.hash(into: &hasher)
    }

}

public class TableDataSource: UITableViewDiffableDataSource<TableSection, AnyTableRow> {

    // MARK: Config

    public static func configure(with tableView: UITableView) -> TableDataSource {
        let ds = TableDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, row) -> UITableViewCell? in
                return row.cell(for: tableView, at: indexPath)
        })
        ds.defaultRowAnimation = .fade
        return ds
    }

    // MARK: Data

    public var sections: [TableSection] = []

    public subscript(indexPath: IndexPath) -> AnyTableRow {
        return sections[indexPath.section].rows[indexPath.row]
    }

    public var isEmpty: Bool {
        return sections.first(where: {!$0.rows.isEmpty}) == nil
    }

    public func setRows(_ rows: [AnyTableRow]?, animated: Bool = true) {
        let section = TableSection(identifier: "defaultSection", rows: rows ?? [])
        setSections([section], animated: animated)
    }

    public func setSections(_ sections: [TableSection]?, animated: Bool = true) {
        self.sections = sections ?? []

        var snapshot = NSDiffableDataSourceSnapshot<TableSection, AnyTableRow>()

        if let sections = sections, !sections.isEmpty {
            snapshot.appendSections(sections)
            sections.forEach {
                snapshot.appendItems($0.rows, toSection: $0)
            }
        }

        apply(snapshot, animatingDifferences: animated)
    }

    // MARK: Data Source Overrides

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    public override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

}
