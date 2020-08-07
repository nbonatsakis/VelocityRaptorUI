//
//  InputField.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import VelocityRaptorCore

public class InputField: NSObject {
    let fieldName: String

    init(fieldName: String) {
        self.fieldName = fieldName
    }

    func validate(showInlineErrors: Bool = true) -> Bool {
        return true
    }

    func setError(_ error: String) {
        fatalError("Subclasses must override")
    }

    func focus() {
        fatalError("Subclasses must override")
    }

}

public class StringInputField: InputField {

    var value: String?
    let validator: FieldValidator?

    init(fieldName: String, validationRules: [FieldValidationRule]?) {
        if let validationRules = validationRules {
            validator = FieldValidator(fieldName: fieldName, rules: validationRules)
        }
        else {
            validator = nil
        }
        super.init(fieldName: fieldName)
    }

    override func validate(showInlineErrors: Bool = true) -> Bool {
        if let validator = validator {
            do {
                try validator.validate(value ?? "")
                return true
            }
            catch let error as ValidationError {
                if showInlineErrors {
                    let message = error.validationErrors.first?.localizedDescription ?? NSLocalizedString("A problem has occurred.", comment: "")
                    setError(message)
                }
                return false
            }
            catch {
                if showInlineErrors {
                    setError(error.localizedDescription)
                }
                return false
            }
        }
        else {
            return true
        }
    }

}
