//
//  InfoStateContentView.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import Then
import VelocityRaptorCore

public class InfoStateContentView: UIView {

    // MARK: Subviews

    let titleLabel = UILabel().then { label in
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .center
    }
    let messageLabel = UILabel().then { label in
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
    }
    let imageView = UIImageView().then { imageView in
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tertiaryLabel
        imageView.heightAnchor == 180
    }
    let primaryButton = UIButton.primary()
    let secondaryButton = UIButton.text()
    let stackView = UIStackView().then { stackView in
        stackView.axis = .vertical
    }

    let emptyState: InfoState

    // MARK: Init

    public init(emptyState: InfoState) {
        self.emptyState = emptyState
        super.init(frame: .zero)

        backgroundColor = .clear

        titleLabel.text = emptyState.title
        messageLabel.text = emptyState.message
        imageView.image = emptyState.image

        if let primaryAction = emptyState.primaryAction {
            primaryButton.setTitle(primaryAction.title.localizedUppercase, for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryActionTapped), for: .touchUpInside)
        }
        if let secondaryAction = emptyState.secondaryAction {
            secondaryButton.setTitle(secondaryAction.title, for: .normal)
            secondaryButton.addTarget(self, action: #selector(secondaryActionTapped), for: .touchUpInside)
        }

        configureView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Config

    func configureView() {
        addSubview(stackView)

        stackView.edgeAnchors == edgeAnchors
        stackView.widthAnchor == 280

        if imageView.image != nil {
            stackView.add([
                imageView,
                StackableItem.spaceAfter(imageView, VelocityRaptorConfig.padding3)
            ])
        }
        if titleLabel.text != nil {
            stackView.add([
                titleLabel,
                StackableItem.spaceAfter(titleLabel, VelocityRaptorConfig.padding2)
            ])
        }
        if messageLabel.text != nil {
            stackView.add([
                messageLabel,
                StackableItem.spaceAfter(messageLabel, VelocityRaptorConfig.padding4)
            ])

        }
        if primaryButton.titleLabel?.text != nil {
            stackView.addArrangedSubview(primaryButton)
        }
        if secondaryButton.titleLabel?.text != nil {
            stackView.add([
                StackableItem.constantSpace(VelocityRaptorConfig.padding1),
                secondaryButton
            ])
        }
    }

    // MARK: Actions

    @objc func primaryActionTapped() {
        emptyState.primaryAction?.handler?()
    }

    @objc func secondaryActionTapped() {
        emptyState.secondaryAction?.handler?()
    }

}
