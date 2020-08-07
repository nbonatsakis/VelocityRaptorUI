//
//  AlignmentView.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Anchorage
import Then

/// View wrapper that lets you specify internal alignment. For use in a stack view.
final class AlignmentView: UIView {

    // swiftlint:disable operator_usage_whitespace

    struct Alignment: OptionSet {
        let rawValue: Int
        static let leading          = Alignment(rawValue: 1 << 0)
        static let left             = Alignment(rawValue: 1 << 1)
        static let centerX          = Alignment(rawValue: 1 << 2)
        static let right            = Alignment(rawValue: 1 << 3)
        static let trailing         = Alignment(rawValue: 1 << 4)
        static let fillHorizontal   = Alignment(rawValue: 1 << 5)
        static let flexHorizontal   = Alignment(rawValue: 1 << 6)

        static let top              = Alignment(rawValue: 1 << 7)
        static let centerY          = Alignment(rawValue: 1 << 8)
        static let bottom           = Alignment(rawValue: 1 << 9)
        static let fillVertical     = Alignment(rawValue: 1 << 10)
        static let flexVertical     = Alignment(rawValue: 1 << 11)

        fileprivate static let Horizontal: Alignment = [.leading, .left, .centerX, .right, .trailing, .fillHorizontal, .flexHorizontal]
        fileprivate static let Vertical: Alignment = [.top, .centerY, .bottom, .fillVertical, .flexVertical]
    }

    // swiftlint:enable operator_usage_whitespace

    private var isHiddenObservation: NSKeyValueObservation?

    required init(_ wrapped: UIView, alignment: Alignment, inset: UIEdgeInsets = .zero) {
        super.init(frame: .zero)
        layoutMargins = inset

        addSubview(wrapped)

        var alignment = alignment
        if alignment.isDisjoint(with: Alignment.Horizontal) {
            alignment.formUnion(.fillHorizontal)
        }
        if alignment.isDisjoint(with: Alignment.Vertical) {
            alignment.formUnion(.fillVertical)
        }

        if alignment.contains(.leading) { wrapped.leadingAnchor == layoutMarginsGuide.leadingAnchor }
        if alignment.contains(.left) { wrapped.leftAnchor == layoutMarginsGuide.leftAnchor }
        if alignment.contains(.centerX) { wrapped.centerXAnchor == layoutMarginsGuide.centerXAnchor }
        if alignment.contains(.right) { wrapped.rightAnchor == layoutMarginsGuide.rightAnchor }
        if alignment.contains(.trailing) { wrapped.trailingAnchor == layoutMarginsGuide.trailingAnchor }
        if alignment.contains(.fillHorizontal) { wrapped.horizontalAnchors == layoutMarginsGuide.horizontalAnchors }

        if alignment.contains(.top) { wrapped.topAnchor == layoutMarginsGuide.topAnchor }
        if alignment.contains(.centerY) { wrapped.centerYAnchor == layoutMarginsGuide.centerYAnchor }
        if alignment.contains(.bottom) { wrapped.bottomAnchor == layoutMarginsGuide.bottomAnchor }
        if alignment.contains(.fillVertical) { wrapped.verticalAnchors == layoutMarginsGuide.verticalAnchors }

        wrapped.edgeAnchors >= layoutMarginsGuide.edgeAnchors

        isHiddenObservation = wrapped.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (view, _) in
            self?.isHidden = view.isHidden
        })
    }

    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
