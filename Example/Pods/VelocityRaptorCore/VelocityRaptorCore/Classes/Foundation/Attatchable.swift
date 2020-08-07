//
//  Attatchable.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Foundation

public protocol Attachable {

    func attach(to child: AnyObject)
    func detatch(from child: AnyObject)

}

private var strongKey = "com.util.attachable.strong"
private var weakKey = "com.util.attachable.weak"
public extension Attachable where Self: NSObject {

    func attach(to child: AnyObject) {
        addStrongReference(from: child, to: self)
        addWeakReference(from: self, to: child)
    }

    func detatch(from child: AnyObject) {
        strongReferences(from: child)?.remove(self)
        weakReferences(from: self)?.remove(child)
    }

    var attached: [AnyObject] {
        return (weakReferences(from: self) as NSHashTable<AnyObject>?)?.allObjects ?? []
    }

    // MARK: Helpers
    private func strongReferences(from object: AnyObject) -> NSMutableArray? {
        return objc_getAssociatedObject(object, &strongKey) as? NSMutableArray
    }

    private func weakReferences(from object: AnyObject) -> NSHashTable<AnyObject>? {
        return objc_getAssociatedObject(object, &weakKey) as? NSHashTable<AnyObject>
    }

    private func addStrongReference(from source: AnyObject, to destination: AnyObject) {
        let attached = (objc_getAssociatedObject(source, &strongKey) as? NSMutableArray)
            ?? NSMutableArray().then {
                objc_setAssociatedObject(source, &strongKey, $0, .OBJC_ASSOCIATION_RETAIN)
        }
        attached.add(destination)
    }

    private func addWeakReference(from source: AnyObject, to destination: AnyObject) {
        let attached = (objc_getAssociatedObject(source, &weakKey) as? NSHashTable) ??
            NSHashTable<AnyObject>.weakObjects().then {
                objc_setAssociatedObject(source, &weakKey, $0, .OBJC_ASSOCIATION_RETAIN)
        }
        attached.add(destination)
    }

}
