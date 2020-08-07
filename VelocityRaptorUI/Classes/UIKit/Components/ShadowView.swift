//
//  ShadowView.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import MaterialComponents
import VelocityRaptorCore

public class ShadowView: UIView {

    public override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }

    public var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }

    public func setElevation(_ elevation: ShadowElevation) {
        self.shadowLayer?.elevation = elevation
    }

    public func enableRasterize() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        enableRasterize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public class CardView: ShadowView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setElevation(.cardResting)
        layer.cornerRadius = VelocityRaptorConfig.defaultCornerRadius
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

public class ShadowButton: BetterButton {

    public override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }

    var shadowLayer: MDCShadowLayer? {
        return self.layer as? MDCShadowLayer
    }

    func setElevation(_ elevation: ShadowElevation) {
        self.shadowLayer?.elevation = elevation
    }

    func enableRasterize() {
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

}
