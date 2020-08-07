//
//  TableDataSource.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Reusable

struct TableSection: Hashable {

    let identifier: AnyHashable
    let header: String?
    let footer: String?
    let rows: [AnyTableRow]

    init(
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

    func hash(into hasher: inout Hasher) {
        identifier.hash(into: &hasher)
    }

}

class TableDataSource: UITableViewDiffableDataSource<TableSection, AnyTableRow> {

    // MARK: Config

    static func configure(with tableView: UITableView) -> TableDataSource {
        let ds = TableDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, row) -> UITableViewCell? in
                return row.cell(for: tableView, at: indexPath)
        })
        ds.defaultRowAnimation = .fade
        return ds
    }

    // MARK: Data

    var sections: [TableSection] = []

    subscript(indexPath: IndexPath) -> AnyTableRow {
        return sections[indexPath.section].rows[indexPath.row]
    }

    var isEmpty: Bool {
        return sections.first(where: {!$0.rows.isEmpty}) == nil
    }

    func setRows(_ rows: [AnyTableRow]?, animated: Bool = true) {
        let section = TableSection(identifier: "defaultSection", rows: rows ?? [])
        setSections([section], animated: animated)
    }

    func setSections(_ sections: [TableSection]?, animated: Bool = true) {
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

}
