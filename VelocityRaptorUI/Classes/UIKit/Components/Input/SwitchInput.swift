//
//  SwitchInput.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Then
import VelocityRaptorCore

public class SwitchInput: InputField {

    var value: Bool = false {
        didSet {
            toggle.isOn = value
        }
    }
    let toggle = UISwitch()
    let label = UILabel(labelText: nil, textStyle: .callout)
    lazy var view = UIStackView(arrangedSubviews: [label, toggle]).then {
        $0.spacing = VRC.padding1
        $0.alignment = .center
    }

    override init(fieldName: String) {
        super.init(fieldName: fieldName)
        label.text = fieldName
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        toggle.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc func valueChanged() {
        value = toggle.isOn
    }
}
