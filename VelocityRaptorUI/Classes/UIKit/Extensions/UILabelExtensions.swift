//
//  UILabelExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

public extension UILabel {

    // Font reference; https://gist.github.com/zacwest/916d31da5d03405809c4

    convenience init(labelText: String?, textStyle: UIFont.TextStyle) {
        self.init()
        font = .preferredFont(forTextStyle: textStyle)
        textColor = .label
        text = labelText
        numberOfLines = 0
    }

}
