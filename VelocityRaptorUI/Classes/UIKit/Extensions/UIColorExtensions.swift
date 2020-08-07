//
//  ColorExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

public extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = UInt8((hex & 0xFF0000) >> 16)
        let g = UInt8((hex & 0xFF00) >> 8)
        let b = UInt8(hex & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: alpha)
    }

    convenience init(rgba: UInt32) {
        let r = UInt8((rgba & 0xFF000000) >> 24)
        let g = UInt8((rgba & 0xFF0000) >> 16)
        let b = UInt8((rgba & 0xFF00) >> 8)
        let a = UInt8(rgba & 0xFF)
        self.init(red8: r, green8: g, blue8: b, alpha: CGFloat(a) / 255)
    }

    convenience init(red8: UInt8, green8: UInt8, blue8: UInt8, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red8) / 255.0, green: CGFloat(green8) / 255.0, blue: CGFloat(blue8) / 255.0, alpha: alpha)
    }

    func lightened(by percentage: CGFloat) -> UIColor {
        return self.brightnessAdjusted(by: abs(percentage) )
    }

    func darkened(by percentage: CGFloat) -> UIColor {
        return self.brightnessAdjusted(by: -1 * abs(percentage) )
    }

    var averageBrightness: CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            return (r + g + b) / 3.0
        }
        else {
            return 1.0
        }

    }

    func brightnessAdjusted(by percentage: CGFloat) -> UIColor {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            return UIColor(red: min(r + percentage, 1.0),
                           green: min(g + percentage, 1.0),
                           blue: min(b + percentage, 1.0),
                           alpha: a)
        }
        else {
            return .black
        }
    }

}

