//
//  CollectionUtils.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Then

extension Collection where Element: BinaryFloatingPoint {

    public var average: Element {
        return reduce(0, +) / Element(count)
    }

}

extension Sequence {
    public func first(_ keyPath: KeyPath<Element, Bool>) -> Element? {
        return self.first {
            return $0[keyPath: keyPath] == true
        }
    }

    public func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return self.map {
            $0[keyPath: keyPath]
        }
    }

    public func compactMap<T>(_ keyPath: KeyPath<Element, T?>) -> [T] {
        return self.compactMap {
            $0[keyPath: keyPath]
        }
    }

    public func flatMap<T>(_ keyPath: KeyPath<Element, [T]>) -> [T] {
        return self.flatMap {
            $0[keyPath: keyPath]
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    public func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension Sequence {
    public func unique<T: Hashable>(by keyPath: KeyPath<Element, T>) -> [Iterator.Element] {
        var seen: [T: Bool] = [:]
        return self.filter { seen.updateValue(true, forKey: $0[keyPath: keyPath]) == nil }
    }
}

extension Array {
    public func compact<ElementOfResult>() -> [ElementOfResult] {
        return compactMap { $0 as? ElementOfResult }
    }
}

extension Array where Element: Sequence {
    public func flat() -> [Element.Element] {
        return flatMap({$0})
    }
}

extension Collection {

    public func joined(separator: Element) -> [Element] {
        return joined(makeSeparator: separator)
    }

    public func joined(makeSeparator: @escaping @autoclosure () -> Element) -> [Element] {
        let iterator = AnyIterator(makeSeparator)
        return Array(zip(self, iterator).flatMap { [$0.0, $0.1] }.dropLast())
    }

    public subscript (safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        else {
            return nil
        }
    }

}

extension Collection where SubSequence: Sequence {

    public var byPairs: Zip2Sequence<Self, SubSequence> {
        return zip(self, self.dropFirst())
    }

}
