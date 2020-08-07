//
//  TextInput.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import MaterialComponents
import Then
import VelocityRaptorCore

public class TextInput: StringInputField {

    let textField: TextField
    let controller: MDCTextInputControllerBase
    override var value: String? {
        didSet {
            textField.text = value
        }
    }

    init(placeholder: String, validationRules: [FieldValidationRule]? = nil) {
        textField = TextField()
        textField.autocapitalizationType = .none
        controller = MDCTextInputControllerOutlined(textInput: textField)
        controller.placeholderText = placeholder
        controller.inlinePlaceholderColor = VRC.textFieldTintInactive
        controller.textInput?.textColor = VRC.textFieldText
        controller.floatingPlaceholderActiveColor = VRC.textFieldTintActive
        controller.floatingPlaceholderNormalColor = VRC.textFieldTintInactive
        controller.activeColor = VRC.textFieldTintActive
        controller.normalColor = VRC.textFieldTintInactive
        controller.errorColor = VRC.textFieldTintError

        super.init(fieldName: placeholder, validationRules: validationRules)

        textField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(onTextDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: textField)
    }

    var isEmpty: Bool {
        return textField.text?.isEmpty ?? true
    }

    func resetErrors() {
        controller.setErrorText(nil, errorAccessibilityValue: nil)
    }

    override func setError(_ message: String) {
        controller.setErrorText(message, errorAccessibilityValue: message)
    }

    override func focus() {
        textField.becomeFirstResponder()
    }

    @objc func handleTextChange() {
        value = textField.text
        resetErrors()
    }

    @objc func onTextDidBeginEditing() {
    }

}

class TextField: MDCTextField {

    var isCursorEnabled: Bool = true
    var additionalEdgeInsets: UIEdgeInsets?

    override func caretRect(for position: UITextPosition) -> CGRect {
        return isCursorEnabled ? super.caretRect(for: position) : .zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return isCursorEnabled ? super.selectionRects(for: range) : []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return isCursorEnabled ? super.canPerformAction(action, withSender: sender) : false
    }

}
