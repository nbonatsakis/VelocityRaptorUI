//
//  StackViewExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Foundation
import Anchorage
import VelocityRaptorCore

public protocol Stackable {
    func configure(stack: UIStackView)
}

extension UIStackView {

    func add(_ stackable: Stackable) {
        stackable.configure(stack: self)
    }

    func add(_ stackables: [Stackable]) {
        stackables.forEach { $0.configure(stack: self) }
    }

    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }

    func insertArrangedSubview(_ view: UIView, aboveArrangedSubview other: UIView) {
        if let idx = arrangedSubviews.firstIndex(of: other) {
            insertArrangedSubview(view, at: idx)
        }
        else {
            addArrangedSubview(view)
        }
    }

    func insertArrangedSubview(_ view: UIView, belowArrangedSubview other: UIView) {
        if let idx = arrangedSubviews.firstIndex(of: other)?.advanced(by: 1) {
            insertArrangedSubview(view, at: idx)
        }
        else {
            addArrangedSubview(view)
        }
    }

}

extension UIView: Stackable {
    public func configure(stack: UIStackView) {
        stack.addArrangedSubview(self)
    }
}

extension UIViewController: Stackable {
    public func configure(stack: UIStackView) {
        stack.addArrangedSubview(view)
    }
}

extension CGFloat: Stackable {
    public func configure(stack: UIStackView) {
        stack.add([StackableItem.space(self)])
    }
}

extension CGFloat {
    func after(_ view: UIView) -> StackableItem {
        return StackableItem.spaceAfter(view, self)
    }
}

extension NSAttributedString: Stackable {
    public func configure(stack: UIStackView) {
        stack.addArrangedSubview(UILabel().then {
            $0.attributedText = self
            $0.numberOfLines = 0
        })
    }
}

extension UIImage: Stackable {
    public func configure(stack: UIStackView) {
        let imageView = UIImageView(image: self)
        imageView.contentMode = .scaleAspectFit
        imageView.configure(stack: stack)
    }
}

extension String: Stackable {
    public func configure(stack: UIStackView) {
        NSAttributedString(string: self).configure(stack: stack)
    }
}

extension UILayoutGuide: Stackable {
    public func configure(stack: UIStackView) {
        let view = UIView()
        view.addLayoutGuide(self)
        view.edgeAnchors == edgeAnchors
        stack.addArrangedSubview(view)
    }
}

extension UIStackView {
    static func space(_ space: CGFloat) -> StackableItem {
        return StackableItem.space(space)
    }
    static func space(after view: UIView, _ space: CGFloat) -> StackableItem {
        return StackableItem.spaceAfter(view, space)
    }
    static func space(before view: UIView, _ space: CGFloat) -> StackableItem {
        return StackableItem.spaceBefore(view, space)
    }
    static func constantSpace(_ space: CGFloat) -> StackableItem {
        return StackableItem.constantSpace(space)
    }
    static func flexibleSpace(_ flexibleSpace: StackableItem.FlexibleSpace = .atLeast(0)) -> StackableItem {
        return StackableItem.flexibleSpace(flexibleSpace)
    }
    static var flexibleSpace: StackableItem {
        return UIStackView.flexibleSpace()
    }
}

extension Array: Stackable where Element: Stackable {

    public func configure(stack: UIStackView) {
        forEach { $0.configure(stack: stack) }
    }

}

enum StackableItem {
    case space(CGFloat)
    case constantSpace(CGFloat)
    case spaceBefore(UIView, CGFloat)
    case spaceAfter(UIView, CGFloat)
    case flexibleSpace(FlexibleSpace)

    enum FlexibleSpace {
        case atLeast(CGFloat)
        case range(Range<CGFloat>)
        case atMost(CGFloat)
    }

    case hairline(StackableHairline)

    case end
}

extension StackableItem: Stackable {

    func configure(stack: UIStackView) {
        switch self {
        case let .space(space):
            if let view = stack.arrangedSubviews.last {
                StackableItem.spaceAfter(view, space).configure(stack: stack)
            }
            else {
                StackableItem.constantSpace(space).configure(stack: stack)
            }

        case let .constantSpace(space):
            let spacer = UIView()
            spacer.dimension(along: stack.axis) == space
            stack.addArrangedSubview(spacer)

        case let .spaceBefore(view, space):
            let spacer = UIView()
            spacer.dimension(along: stack.axis) == space
            stack.addArrangedSubview(spacer)
            spacer.bindVisible(to: view)

        case let .spaceAfter(view, space):
            stack.setCustomSpacing(space, after: view)

        case let .flexibleSpace(.atLeast(space)):
            let spacer = UIView()
            spacer.dimension(along: stack.axis) >= space
            stack.addArrangedSubview(spacer)

        case let .flexibleSpace(.range(range)):
            let spacer = UIView()
            let anchor = spacer.dimension(along: stack.axis)
            anchor <= range.upperBound
            anchor >= range.lowerBound
            stack.addArrangedSubview(spacer)

        case let .flexibleSpace(.atMost(space)):
            let spacer = UIView()
            spacer.dimension(along: stack.axis) <= space
            stack.addArrangedSubview(spacer)

        case let .hairline(item):
            item.configure(stack: stack)

        case .end:
            let view = UIView()
            view.dimension(along: stack.axis) == 0
            stack.addArrangedSubview(view)
        }
    }

}

extension StackableItem {

    struct StackableHairline: Stackable {
        let type: StackableHairlineType
        var configure: ((HairlineView) -> Void)?
    }

    enum StackableHairlineType {
        case after(UIView?)
        case between(UIView?, UIView?)
        case before(UIView?)
        case around(UIView?)
    }

}

extension UIStackView {
    static var hairline: StackableItem.StackableHairline {
        return .init(type: .after(nil), configure: nil)
    }
    static func hairline(after view: UIView) -> StackableItem.StackableHairline {
        return .init(type: .after(view), configure: nil)
    }
    static func hairlineBetween(_ view1: UIView?, _ view2: UIView?) -> StackableItem.StackableHairline {
        return .init(type: .between(view1, view2), configure: nil)
    }
    static func hairline(before view: UIView?) -> StackableItem.StackableHairline {
        return .init(type: .before(view), configure: nil)
    }
    static func hairline(around view: UIView?) -> StackableItem.StackableHairline {
        return .init(type: .around(view), configure: nil)
    }
    static func hairlines(between views: [UIView]) -> [StackableItem.StackableHairline] {
        return views.byPairs.map { UIStackView.hairlineBetween($0.0, $0.1) }
    }
    static func hairlines(after views: [UIView]) -> [StackableItem.StackableHairline] {
        return views.map { UIStackView.hairline(after: $0) }
    }
    static func hairlines(around views: [UIView]) -> [StackableItem.StackableHairline] {
        return views.map { $0 == views.first
            ? UIStackView.hairline(around: $0)
            : UIStackView.hairline(after: $0)
        }
    }
}

extension StackableItem.StackableHairline {

    func inset(by insets: UIEdgeInsets) -> StackableItem.StackableHairline {
        var item = self
        item.configure = {
            self.configure?($0)
            $0.layoutMargins = insets
        }
        return item
    }

    func configure(stack: UIStackView) {
        let hairlineAxis: NSLayoutConstraint.Axis = (stack.axis == .horizontal) ? .vertical : .horizontal
        func makeHairline() -> HairlineView {
            let hairline = Hairline(
                axis: hairlineAxis,
                configuration: configure
                ).makeConfiguredView()
            hairline.bindVisible(to: allViews)
            return hairline
        }

        if let view = hairlineBeforeView {
            stack.insertArrangedSubview(makeHairline(), aboveArrangedSubview: view)
        }
        if let view = hairlineAfterView {
            stack.insertArrangedSubview(makeHairline(), belowArrangedSubview: view)
        }
        if allViews.isEmpty {
            stack.addArrangedSubview(makeHairline())
        }
    }

    private var allViews: [UIView] {
        switch type {
        case .after(let view): return [view].compact()
        case .between(let v0, let v1): return [v0, v1].compact()
        case .before(let view): return [view].compact()
        case .around(let view): return [view].compact()
        }
    }

    private var hairlineAfterView: UIView? {
        switch type {
        case .after(let view): return view
        case .between(let v0, _): return v0
        case .before: return nil
        case .around(let view): return view
        }
    }

    private var hairlineBeforeView: UIView? {
        switch type {
        case .after: return nil
        case .between: return nil
        case .before(let view): return view
        case .around(let view): return view
        }
    }
}

extension Array where Element == StackableItem.StackableHairline {
    func inset(by insets: UIEdgeInsets) -> [Element] {
        return map { $0.inset(by: insets) }
    }
}

private extension UIView {

    func dimension(along axis: NSLayoutConstraint.Axis) -> NSLayoutDimension {
        switch axis {
        case .vertical: return heightAnchor
        case .horizontal: return widthAnchor
        @unknown default: fatalError()
        }
    }

}

extension NSKeyValueObservation: Attachable {}
extension Stackable where Self: UIView {

    func bindVisible(to views: [UIView]) {
        views.forEach { view in
            let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (_, _) in
                self?.isHidden = views.contains { $0.isHidden }
            })
            isHiddenObservation.attach(to: self)
        }
    }

    func bindVisible(to view: UIView) {
        let isHiddenObservation = view.observe(\.isHidden, options: .initial, changeHandler: { [weak self] (view, _) in
            self?.isHidden = view.isHidden
        })
        isHiddenObservation.attach(to: self)
    }

}

extension Hairline {
    enum Parameters {
        static var color: UIColor = .separator
    }
}

struct Hairline {
    var axis = NSLayoutConstraint.Axis.horizontal
    var thickness: CGFloat
    var configuration: ((HairlineView) -> Void)?

    init(axis: NSLayoutConstraint.Axis = .horizontal, thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale), configuration: ((HairlineView) -> Void)? = nil) {
        self.axis = axis
        self.thickness = thickness
        self.configuration = configuration
    }

    func makeConfiguredView() -> HairlineView {
        return HairlineView(
            axis: axis,
            thickness: thickness,
            hairlineColor: Parameters.color
        ).then {
            $0.layoutMargins = .zero
            let huggingAxis: NSLayoutConstraint.Axis = (axis == .horizontal) ? .vertical : .horizontal
            $0.setContentHuggingPriority(.required, for: huggingAxis)
            $0.setContentCompressionResistancePriority(.required, for: huggingAxis)
            configuration?($0)
        }
    }
}
