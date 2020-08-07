//
//  ListInput.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import MaterialComponents
import Then
import Anchorage
import VelocityRaptorCore

public class ListInput: TextInput {

    let picker: ListInputPickerViewController
    override var value: String? {
        didSet {
            if let selectedValue = value, let index = picker.items.firstIndex(of: selectedValue) {
                textField.text = selectedValue
                picker.pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            else {
                textField.text = ""
            }
        }
    }

    init(placeholder: String, items: [String], validationRules: [FieldValidationRule]?) {
        picker = ListInputPickerViewController(items: items)
        super.init(placeholder: placeholder, validationRules: validationRules)

        picker.delegate = self
        textField.isCursorEnabled = false
        textField.inputView = picker.view
    }

    override func onTextDidBeginEditing() {
        if value == nil {
            value = picker.items.first
        }
    }
}

// MARK: ListInputPickerViewControllerDelegate
extension ListInput: ListInputPickerViewControllerDelegate {

    func listInputPickerViewController(_ controller: ListInputPickerViewController, didChangeValue value: String) {
        self.value = value
    }

}

// MARK: ListInputPickerViewController
protocol ListInputPickerViewControllerDelegate: class {

    func listInputPickerViewController(_ controller: ListInputPickerViewController, didChangeValue value: String)

}

public class ListInputPickerViewController: UIViewController {

    lazy var pickerView = UIPickerView(frame: .zero).then { picker in
        picker.delegate = self
        picker.dataSource = self
    }
    let items: [String]
    weak var delegate: ListInputPickerViewControllerDelegate?

    init(items: [String]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pickerView)
        pickerView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
    }

}

// MARK: UIPickerViewDataSource
extension ListInputPickerViewController: UIPickerViewDataSource {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

}

// MARK: UIPickerViewDelegate
extension ListInputPickerViewController: UIPickerViewDelegate {

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.listInputPickerViewController(self, didChangeValue: items[row])
    }

}
