//
//  ImageExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Foundation
import UIKit

// Originally sourced from BonMot: https://github.com/Raizlabs/BonMot/blob/master/Sources/Image%2BTinting.swift
// Please apply any improvments made here to source.
public extension UIImage {

    /// Returns a copy of the receiver where the alpha channel is maintained,
    /// but every pixel's color is replaced with `color`.
    ///
    /// - note: The returned image does _not_ have the template flag set,
    ///         preventing further tinting.
    ///
    /// - Parameter theColor: The color to use to tint the receiver.
    /// - Returns: A tinted copy of the image.
    func vr_tintedImage(color theColor: UIColor) -> UIImage {
        let imageRect = CGRect(origin: .zero, size: size)
        // Save original properties
        let originalCapInsets = capInsets
        let originalResizingMode = resizingMode
        let originalAlignmentRectInsets = alignmentRectInsets

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }

        // Flip the context vertically
        context.translateBy(x: 0.0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // Image tinting mostly inspired by http://stackoverflow.com/a/22528426/255489
        context.setBlendMode(.normal)
        context.draw(cgImage!, in: imageRect)

        // .sourceIn: resulting color = source color * destination alpha
        context.setBlendMode(.sourceIn)
        context.setFillColor(theColor.cgColor)
        context.fill(imageRect)

        // Get new image
        guard var image = UIGraphicsGetImageFromCurrentImageContext() else {
            return self
        }
        UIGraphicsEndImageContext()

        // Prevent further tinting
        image = image.withRenderingMode(.alwaysOriginal)

        // Restore original properties
        image = image.withAlignmentRectInsets(originalAlignmentRectInsets)
        if originalCapInsets != image.capInsets || originalResizingMode != image.resizingMode {
            image = image.resizableImage(withCapInsets: originalCapInsets, resizingMode: originalResizingMode)
        }

        // Transfer accessibility label (watchOS not included; does not have accessibilityLabel on UIImage).
        image.accessibilityLabel = self.accessibilityLabel

        return image
    }

}
