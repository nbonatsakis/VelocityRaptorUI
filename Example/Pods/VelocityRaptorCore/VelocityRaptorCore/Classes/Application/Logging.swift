//
//  Logging.swift
//  Anchorage
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//

import Foundation

public protocol Logger {

    func warn(_ message: String)
    func error(_ message: String)
    func info(_ message: String)
    func debug(_ message: String)

}

internal class DefaultLogger: Logger {

    func warn(_ message: String) {}
    func error(_ message: String) {}
    func info(_ message: String) {}
    func debug(_ message: String) {}

}
