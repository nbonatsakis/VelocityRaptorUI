//
//  ButtonExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import VelocityRaptorCore

public extension UIButton {

    static func primary(withTitle title: String? = nil, backgroundColor: UIColor = VelocityRaptorConfig.primaryButtonBackground, foregroundColor: UIColor = VelocityRaptorConfig.primaryButtonForeground) -> UIButton {
        let button = BetterButton(shape: .rectangle(cornerRadius: VelocityRaptorConfig.defaultCornerRadius), style: .solid(backgroundColor: backgroundColor, foregroundColor: foregroundColor))
        button.heightAnchor == 50
        if let title = title {
            button.setTitle(title.localizedUppercase, for: .normal)
        }
        return button
    }

    static func primaryOutlined(withTitle title: String? = nil, backgroundColor: UIColor = .systemBackground, tintColor: UIColor = VelocityRaptorConfig.primaryButtonBackground) -> UIButton {
        let button = BetterButton(shape: .rectangle(cornerRadius: VelocityRaptorConfig.defaultCornerRadius), style: .outlineInvert(backgroundColor: backgroundColor, foregroundColor: tintColor))
        button.heightAnchor == 50
        if let title = title {
            button.setTitle(title.localizedUppercase, for: .normal)
        }
        return button
    }

    static func text(withTitle title: String? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = VelocityRaptorConfig.primaryButtonBackground
        button.titleLabel?.textAlignment = .center
        if let title = title {
            button.setTitle(title.localizedUppercase, for: .normal)
        }
        return button
    }

    static func textAndIcon(title: String, icon: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.tintColor = VelocityRaptorConfig.primaryButtonBackground
        button.setTitle(title, for: .normal)
        button.setImage(icon, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: VelocityRaptorConfig.padding1, bottom: 0, right: -VelocityRaptorConfig.padding1)
        return button
    }

}

