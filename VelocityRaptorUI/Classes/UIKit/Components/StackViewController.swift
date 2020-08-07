//
//  StackViewController.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Then
import Anchorage
import VelocityRaptorCore

public class StackViewController: UIViewController {

    public let scrollView = UIScrollView().then { scrollView in
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
    }
    public let stackView = UIStackView().then { stackView in
        stackView.axis = .vertical
    }
    public var defaultLayoutMargins: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: VRC.padding1, leading: VRC.padding2, bottom: VRC.padding1, trailing: VRC.padding2)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.directionalLayoutMargins = defaultLayoutMargins
        viewRespectsSystemMinimumLayoutMargins = false

        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        let keyboardGuide = view.addKeyboardLayoutGuide()
        scrollView.topAnchor == view.topAnchor
        scrollView.horizontalAnchors == view.horizontalAnchors
        scrollView.bottomAnchor == keyboardGuide.topAnchor

        stackView.verticalAnchors == scrollView.contentLayoutGuide.verticalAnchors
        stackView.leadingAnchor == scrollView.frameLayoutGuide.leadingAnchor + view.directionalLayoutMargins.leading
        stackView.trailingAnchor == scrollView.frameLayoutGuide.trailingAnchor - view.directionalLayoutMargins.trailing
        scrollView.contentInset.top = view.directionalLayoutMargins.top
        scrollView.contentInset.bottom = view.directionalLayoutMargins.bottom
    }

}
