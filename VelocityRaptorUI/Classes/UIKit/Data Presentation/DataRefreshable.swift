//
//  DataRefreshable.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

protocol DataRefreshable: EmptyStateDisplayable {

    var tableView: UITableView! { get }
    func configureDataRefresh()
    func loadData(completion: @escaping (() -> Void))

}

extension DataRefreshable where Self: UIViewController {

    func configureDataRefresh() {
        let refreshControl = CustomRefreshControl()
        refreshControl.onRefresh = { [weak self] in
            self?.loadDataAndEndRefresh()
        }
        tableView.refreshControl = refreshControl
    }

    func refresh() {
        tableView.refreshControl?.beginRefreshing()
        loadDataAndEndRefresh()
    }

    private func loadDataAndEndRefresh() {
        loadData { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
            self?.dataChanged()
        }
    }

}

private class CustomRefreshControl: UIRefreshControl {

    var onRefresh: (() -> Void)?

    override init() {
        super.init()
        addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleRefresh() {
        onRefresh?()
    }
    
}
