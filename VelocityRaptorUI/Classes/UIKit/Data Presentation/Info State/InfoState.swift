//
//  InfoState.swift
//  VelocityRaptorCore
//
//  Created by Nicholas Bonatsakis on 7/22/20.
//  Copyright © 2020 Velocity Raptor Incorporated All rights reserved.
//

import UIKit

public struct InfoState: Equatable {

    let title: String?
    let message: String?
    let image: UIImage?
    let primaryAction: InfoStateAction?
    let secondaryAction: InfoStateAction?

    public init(
        title: String? = nil,
        message: String? = nil,
        image: UIImage? = nil,
        primaryAction: InfoStateAction? = nil,
        secondaryAction: InfoStateAction? = nil
    ) {
        self.title = title
        self.message = message
        self.image = image
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }

    public static func == (lhs: InfoState, rhs: InfoState) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.message == rhs.message &&
            lhs.image == rhs.image &&
            lhs.primaryAction == rhs.primaryAction &&
            lhs.secondaryAction == rhs.secondaryAction
    }
    
}

public typealias InfoStateActionHandler = () -> Void

public struct InfoStateAction: Equatable {

    let title: String
    let handler: InfoStateActionHandler?

    public init(title: String, handler: InfoStateActionHandler?) {
        self.title = title
        self.handler = handler
    }

    public static func == (lhs: InfoStateAction, rhs: InfoStateAction) -> Bool {
        return lhs.title == rhs.title
    }
}

