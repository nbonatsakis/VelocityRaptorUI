//
//  InfoStateDisplayable.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage

protocol InfoStateDisplayable {

    var viewForEmptyState: UIView { get }

}

protocol EmptyStateDisplayable: InfoStateDisplayable {

    var emptyState: InfoState { get }
    var dataSource: TableDataSource! { get }

}

extension EmptyStateDisplayable where Self: UIViewController {

    var viewForEmptyState: UIView {
        return self.view
    }

    func dataChanged() {
        if dataSource.isEmpty {
            show(infoState: emptyState)
        }
        else {
            hideEmptyState()
        }
    }

}

extension InfoStateDisplayable where Self: UIViewController {

    var viewForEmptyState: UIView {
        return self.view
    }

    func show(infoState: InfoState, animated: Bool = true) {
        if let existingView = existingEmptyStateView, existingView.contentView.emptyState == infoState {
            return
        }

        show(emptyStateView: InfoStateContentView(emptyState: infoState), animated: animated)
    }

    func show(emptyStateView: InfoStateContentView, animated: Bool = true) {
        hideEmptyState(animated: animated)

        let emptyStateWrapperView = InfoStateView(contentView: emptyStateView)
        emptyStateWrapperView.alpha = 0.0

        viewForEmptyState.addSubview(emptyStateWrapperView)

        if let scrollView = viewForEmptyState as? UIScrollView {
            scrollView.isScrollEnabled = false
            emptyStateWrapperView.edgeAnchors == scrollView.frameLayoutGuide.edgeAnchors
        }
        else {
            emptyStateWrapperView.edgeAnchors == viewForEmptyState.edgeAnchors
        }

        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration) {
            emptyStateWrapperView.alpha = 1.0
        }
    }

    func hideEmptyState(animated: Bool = true) {
        guard let existingView = existingEmptyStateView else {
            return
        }

        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            existingView.alpha = 0.0
        }, completion: { _ in
            existingView.removeFromSuperview()
            if let scrollView = self.viewForEmptyState as? UIScrollView {
                scrollView.isScrollEnabled = true
            }
        })
    }

    var existingEmptyStateView: InfoStateView? {
        for view in viewForEmptyState.subviews {
            if let emptyStateView = view as? InfoStateView {
                return emptyStateView
            }
        }

        return nil
    }

}

class InfoStateView: UIView {

    let contentView: InfoStateContentView

    init(contentView: InfoStateContentView) {
        self.contentView = contentView
        super.init(frame: .zero)

        let keyboard = addKeyboardLayoutGuide()
        let holderView = UIView()
        addSubview(holderView)
        holderView.horizontalAnchors == self.horizontalAnchors
        holderView.topAnchor == self.topAnchor
        holderView.bottomAnchor == keyboard.topAnchor

        holderView.addSubview(contentView)
        contentView.centerAnchors == holderView.centerAnchors
        backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

