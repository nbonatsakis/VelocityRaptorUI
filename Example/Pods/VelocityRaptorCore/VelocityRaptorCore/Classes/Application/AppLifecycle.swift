//
//  AppLifecycle.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 1/24/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

public enum BuildType {

    /// Debug build
    case debug

    /// App store Release build, no flags
    case release

    /// Whether or not this build type is the active build type.
    public static var active: BuildType {
        #if DEBUG
            return .debug
        #else
            return .release
        #endif
    }

}

/**
 *  Objects conforming to this protocol provide some sort of configurable behavior intended for execution
 *  on app launch.
 */
public protocol AppLifecycle {

    /// A check to see if the configuration is enabled.
    var isEnabled: Bool { get }

    /**
     Invoked on UIApplication.applicationDidFinishLaunching to give the conforming instance a chance to execute configuration.

     - parameter application:   The application
     - parameter launchOptions: Optional launch options
     */
    func onDidLaunch(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)

}

public extension AppLifecycle {

    var isEnabled: Bool {
        return true
    }

}
