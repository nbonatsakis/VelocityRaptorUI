//
//  TextArea.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import MaterialComponents
import Then
import VelocityRaptorCore

public class TextAreaInput: StringInputField {

    let textArea: MDCMultilineTextField
    let controller: MDCTextInputControllerBase

    override var value: String? {
        didSet {
            textArea.text = value
        }
    }

    init(placeholder: String, validationRules: [FieldValidationRule]? = nil) {
        textArea = MDCMultilineTextField(frame: .zero)
        textArea.clearButtonMode = .never
        textArea.expandsOnOverflow = false

        controller = MDCTextInputControllerOutlinedTextArea(textInput: textArea)
        controller.placeholderText = placeholder
        controller.inlinePlaceholderColor = VRC.textFieldTintInactive
        controller.textInput?.textColor = VRC.textFieldText
        controller.floatingPlaceholderActiveColor = VRC.textFieldTintActive
        controller.floatingPlaceholderNormalColor = VRC.textFieldTintInactive
        controller.activeColor = VRC.textFieldTintActive
        controller.normalColor = VRC.textFieldTintInactive
        controller.errorColor = VRC.textFieldTintError
        super.init(fieldName: placeholder, validationRules: validationRules)

        textArea.textView?.delegate = self
    }

    var isEmpty: Bool {
        return textArea.text?.isEmpty ?? true
    }

    func resetErrors() {
        controller.setErrorText(nil, errorAccessibilityValue: nil)
    }

    override func setError(_ message: String) {
        controller.setErrorText(message, errorAccessibilityValue: message)
    }

    override func focus() {
        textArea.becomeFirstResponder()
    }

}

extension TextAreaInput: UITextViewDelegate {

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }

    public func textViewDidChange(_ textView: UITextView) {
        value = textView.text
        resetErrors()
    }

}
