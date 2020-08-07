//
//  Clamping.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

public extension Comparable {

    /// Clamp a value to a `ClosedRange`.
    ///
    /// - Parameter to: a `ClosedRange` whose start and end specify the clamp's minimum and maximum.
    /// - Returns: the clamped value.
    func clamped(to range: ClosedRange<Self>) -> Self {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }

    /// Clamp a value to a minimum and maximum value.
    ///
    /// - Parameters:
    ///   - lower: the minimum value allowed.
    ///   - upper: the maximum value allowed.
    /// - Returns: the clamped value.
    func clamped(min lower: Self, max upper: Self) -> Self {
        return min(max(self, lower), upper)
    }

}
