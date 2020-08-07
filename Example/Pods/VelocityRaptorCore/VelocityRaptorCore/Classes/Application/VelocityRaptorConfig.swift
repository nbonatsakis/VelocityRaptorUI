//
//  VelocityRaptorConfig.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import os

public typealias VRC = VelocityRaptorConfig

public struct VelocityRaptorConfig {

    // MARK: Metrics

    public static var padding05: CGFloat = VelocityRaptorConfig.padding1 / 2.0
    public static var padding1: CGFloat = 8.0
    public static var padding15: CGFloat = VelocityRaptorConfig.padding1 * 1.5
    public static var padding2: CGFloat = VelocityRaptorConfig.padding1 * 2
    public static var padding25: CGFloat = VelocityRaptorConfig.padding1 * 2.5
    public static var padding3: CGFloat = VelocityRaptorConfig.padding1 * 3
    public static var padding4: CGFloat = VelocityRaptorConfig.padding1 * 4

    public static var defaultCornerRadius: CGFloat = 6.0

    // MARK: Color

    public static var tint: UIColor = .blue
    public static var secondaryTint: UIColor = .purple
    public static var primaryButtonBackground: UIColor = .blue
    public static var primaryButtonForeground: UIColor = .white

    // MARK: Header

    public static var tableSectionHeaderTextStyle: UIFont.TextStyle = .subheadline
    public static var tableSectionHeaderColor: UIColor = .secondaryLabel
    public static var tableSectionHeaderUppercase: Bool = true

    // MARK: Input

    public static var textFieldText: UIColor = .label
    public static var textFieldTintInactive: UIColor = .secondaryLabel
    public static var textFieldTintActive: UIColor = VRC.tint
    public static var textFieldTintError: UIColor = .red

    // MARK: Logging

    public static var log: Logger = DefaultLogger()

}
