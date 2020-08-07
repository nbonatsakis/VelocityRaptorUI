//
//  UIViewController+Alert.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit
import Anchorage
import VelocityRaptorCore

public typealias VoidClosure = (() -> Void)

// MARK: Alert
public extension UIViewController {

    @nonobjc func showAlert(title: String, message: String, completion: VoidClosure? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .default, handler: {_ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }

    @nonobjc func showAlert(with error: Error?, useErrorDescAsMessage: Bool = false) {
        if let error = error {
            VelocityRaptorConfig.log.error("Error: \(error)")
        }

        var message = NSLocalizedString("A problem has occurred.", comment: "")
        if let desc = error?.localizedDescription, (BuildType.active != .release || useErrorDescAsMessage) {
            message = desc
        }

        showAlert(title: NSLocalizedString("Problem", comment: ""), message: message)
    }

    func showCaptureValueAlert(title: String,
                               message: String,
                               textFieldPlaceholder: String,
                               prepopulateText: String?,
                               submitButtonTitle: String,
                               onSubmit: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
            textField.text = prepopulateText
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: submitButtonTitle, style: .default, handler: { _ in
            if let textField = alert.textFields?.first {
                onSubmit(textField.text)
            }
        }))

        present(alert, animated: true, completion: nil)
    }

}

// MARK: Containment
public extension UIViewController {

    func vr_removeChildViewController(_ child: UIViewController) {
        if child.parent == self {
            child.willMove(toParent: nil)

            if child.view.isDescendant(of: view) {
                child.view.removeFromSuperview()
            }

            child.removeFromParent()
        }
    }

    func vr_addChildViewController(_ child: UIViewController, inView view: UIView) {
        vr_addChildViewController(child, inView: view) { childView in
            childView.edgeAnchors == view.edgeAnchors
        }
    }

    func vr_addChildViewController(_ child: UIViewController, inView view: UIView, layoutBlock: (UIView) -> Void) {
        assert(view.isDescendant(of: self.view), "View must be a descendant of the root view.")

        child.parent?.vr_removeChildViewController(child)

        addChild(child)

        view.addSubview(child.view)
        layoutBlock(child.view)
        
        child.didMove(toParent: self)
    }

    func vr_replaceChildViewController(with newChild: UIViewController, inView view: UIView, animated: Bool) {
        vr_replaceChildViewController(with: newChild, inView: view, animated: animated) { childView in
            childView.edgeAnchors == view.edgeAnchors
        }
    }

    func vr_replaceChildViewController(with newChild: UIViewController, inView view: UIView, animated: Bool, layoutBlock: (UIView) -> Void) {
        guard let oldChild = self.children.first else {
            vr_addChildViewController(newChild, inView: view, layoutBlock: layoutBlock)
            return
        }

        newChild.view.alpha = 0.0
        vr_addChildViewController(newChild, inView: view, layoutBlock: layoutBlock)

        let duration = animated ? 0.3 : 0.0
        UIView.animate(withDuration: duration, animations: {
            newChild.view.alpha = 1.0
            oldChild.view.alpha = 0.0
        }, completion: { _ in
            self.vr_removeChildViewController(oldChild)
        })
    }

}

// MARK: Presentation
public extension UIViewController {

    var visibleViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.visibleViewController
        }
        else {
            return self
        }
    }

    @discardableResult
    func presentInNav(_ controller: UIViewController, animated: Bool = true, completion: VoidClosure? = nil) -> UINavigationController {
        let nav = UINavigationController(rootViewController: controller)
        present(nav, animated: animated, completion: completion)
        return nav
    }

}

public extension UIViewController {

    var isFirstInNavStack: Bool {
        guard let nav = navigationController else {
            return false
        }
        return nav.viewControllers.first == self
    }

}

// MARK: Activity
public extension UIViewController {

    func showInlineLoading() {
        if activeSpinner != nil {
            hideInlineLoading()
        }

        let spinner = ActivityIndicatorView(style: .large)
        spinner.color = VelocityRaptorConfig.tint
        view.addSubview(spinner)
        spinner.startAnimating()
        spinner.centerAnchors == view.centerAnchors
    }

    func hideInlineLoading() {
        guard let spinner = activeSpinner else {
            return
        }

        spinner.removeFromSuperview()
    }

    private var activeSpinner: ActivityIndicatorView? {
        for v in view.subviews {
            if let activityView = v as? ActivityIndicatorView {
                return activityView
            }
        }
        return nil
    }

}

private class ActivityIndicatorView: UIActivityIndicatorView {
}
