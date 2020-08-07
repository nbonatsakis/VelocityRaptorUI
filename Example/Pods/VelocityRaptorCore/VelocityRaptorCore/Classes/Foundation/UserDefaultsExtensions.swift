//
//  UserDefaultsExtensions.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import Foundation

public class Defaults {

    let userDefaults: UserDefaults

    public init(suite: String? = nil) {
        if let suite = suite, let defaults = UserDefaults(suiteName: suite) {
            userDefaults = defaults
        }
        else {
            userDefaults = UserDefaults.standard
        }
    }

    public subscript<T>(key: String) -> T? {
        get {
            return userDefaults.value(forKey: key) as? T
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }

    public subscript<T: RawRepresentable>(key: String) -> T? {
        get {
            if let rawValue = userDefaults.value(forKey: key) as? T.RawValue {
                return T(rawValue: rawValue)
            }
            return nil
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: key)
        }
    }

    public subscript<T: Codable>(key: String) -> T? {
        get {
            return userDefaults.codable(forKey: key)
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }

}

public extension UserDefaults {

    func set<T: Codable>(_ value: T?, forKey key: String) {
        let encoder = JSONEncoder()
        if let val = value, let encoded = try? encoder.encode(val) {
            self.set(encoded, forKey: key)
        } else {
            self.removeObject(forKey: key)
        }
    }

    func codable<T: Codable>(forKey key: String) -> T? {
        let decoder = JSONDecoder()
        guard let data = self.object(forKey: key) as? Data,
            let result = try? decoder.decode(T.self, from: data) else {
                return nil
        }
        return result
    }

}
