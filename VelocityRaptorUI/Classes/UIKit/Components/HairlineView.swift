//
//  HairlineView.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Foundation

open class HairlineView: UIView {

    #if TARGET_INTERFACE_BUILDER
    @IBInspectable open var axis: Int = 0
    #else
    @objc open var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }
    #endif

    @IBInspectable open var thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale) {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsUpdateConstraints()
        }
    }

    @IBInspectable open var hairlineColor: UIColor = UIColor.darkGray {
        willSet {
            update(hairlineColor: newValue)
        }
        didSet {
            setNeedsDisplay()
        }
    }

    public init(axis: NSLayoutConstraint.Axis = .horizontal, thickness: CGFloat = CGFloat(1.0 / UIScreen.main.scale),
                hairlineColor: UIColor = UIColor.darkGray) {
        self.axis = axis
        self.thickness = thickness
        self.hairlineColor = hairlineColor
        super.init(frame: .zero)
        update(hairlineColor: hairlineColor)
        contentMode = .redraw

        setNeedsUpdateConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        if aDecoder.containsValue(forKey: #keyPath(axis)) {
            guard let decodedAxis = NSLayoutConstraint.Axis(rawValue: aDecoder.decodeInteger(forKey: #keyPath(axis))) else {
                return nil
            }
            axis = decodedAxis
        }
        if aDecoder.containsValue(forKey: #keyPath(thickness)) {
            thickness = CGFloat(aDecoder.decodeFloat(forKey: #keyPath(thickness)))
        }
        if aDecoder.containsValue(forKey: #keyPath(hairlineColor)) {
            guard let decodedHairline = aDecoder.decodeObject(forKey: #keyPath(hairlineColor)) as? UIColor else {
                return nil
            }
            hairlineColor = decodedHairline
        }
        super.init(coder: aDecoder)
        setNeedsUpdateConstraints()
    }

    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        hairlineColor.setFill()
        UIRectFill(rect)
    }

    open override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        autoresizingMask.insert([.flexibleHeight, .flexibleWidth])
    }

    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(axis.rawValue, forKey: #keyPath(axis))
        aCoder.encode(thickness, forKey: #keyPath(thickness))
        aCoder.encode(hairlineColor, forKey: #keyPath(hairlineColor))
    }

    open override var intrinsicContentSize: CGSize {
        var size = CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)

        switch axis {
        case .horizontal: size.height = thickness
        case .vertical: size.width = thickness
#if swift(>=5.0)
        @unknown default:
            debugPrint("ERROR: Unhandled NSLayoutConstraint.Axis case \(axis)!")
            break
#endif
        }

        return size
    }

    open override func contentHuggingPriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return (self.axis == axis ? UILayoutPriority.required : UILayoutPriority.defaultLow)
    }

    open override func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return contentHuggingPriority(for: axis)
    }

    private func update(hairlineColor: UIColor) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        hairlineColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        if alpha != 1.0 {
            self.alpha = alpha
            let solid = hairlineColor.withAlphaComponent(1.0)
            self.hairlineColor = solid
        }
    }

}
