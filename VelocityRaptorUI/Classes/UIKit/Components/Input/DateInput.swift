//
//  DateInput.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import MaterialComponents
import Then
import VelocityRaptorCore

public class DateInput: TextInput {

    let datePicker = UIDatePicker().then { datePicker in
        datePicker.date = Date()
    }
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var dateValue: Date?

    override init(placeholder: String, validationRules: [FieldValidationRule]? = nil) {
        super.init(placeholder: placeholder, validationRules: validationRules)
        textField.returnKeyType = .next
        textField.clearButtonMode = .never
        textField.isCursorEnabled = false
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateValueChanged), for: .valueChanged)
    }

    func updateDateInputField() {
        value = dateFormatter.string(from: datePicker.date)
        dateValue = datePicker.date
    }

    @objc func dateValueChanged() {
        updateDateInputField()
    }

    override func onTextDidBeginEditing() {
        updateDateInputField()
    }
}
