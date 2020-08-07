//
//  TextEntryViewController.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Then
import Anchorage
import MaterialComponents
import VelocityRaptorCore

protocol TextEntryViewControllerDelegate: class {
    func textEntryViewControllerDidCancel(controller: TextEntryViewController)
    func textEntryViewController(_ controller: TextEntryViewController, didSaveText text: String?)
}

public class TextEntryViewController: UIViewController {

    lazy var textInput = TextAreaInput(placeholder: placeholder)
    let placeholder: String
    weak var delegate: TextEntryViewControllerDelegate?

    init(title: String, placeholder: String, prepopulateText: String?, delegate: TextEntryViewControllerDelegate?  = nil) {
        self.placeholder = placeholder
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.title = title
        textInput.textArea.text = prepopulateText
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(textInput.textArea)
        textInput.textArea.topAnchor == view.safeAreaLayoutGuide.topAnchor + VRC.padding2
        textInput.textArea.horizontalAnchors == view.safeAreaLayoutGuide.horizontalAnchors + VRC.padding2

        textInput.textArea.becomeFirstResponder()

        textInput.textArea.textView?.delegate = self
        textChanged()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    @objc func textChanged() {
        navigationItem.rightBarButtonItem?.isEnabled = !textInput.isEmpty
    }

    @objc func saveTapped() {
        delegate?.textEntryViewController(self, didSaveText: textInput.textArea.text)
    }

    @objc func cancelTapped() {
        delegate?.textEntryViewControllerDidCancel(controller: self)
    }

}

// MARK: UITextViewDelegate
extension TextEntryViewController: UITextViewDelegate {

    public func textViewDidChange(_ textView: UITextView) {
        textChanged()
    }

}
