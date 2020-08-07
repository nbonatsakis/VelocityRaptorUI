//
//  CardCell.swift
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

public class CardCell: UITableViewCell {

    let cardView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = VRC.defaultCornerRadius
    }
    let outterCardView = ShadowView().then {
        $0.backgroundColor = .clear
        $0.setElevation(.cardResting)
        $0.layer.cornerRadius = VRC.defaultCornerRadius
    }
    var ink: MDCInkTouchController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(outterCardView)
        outterCardView.edgeAnchors == contentView.edgeAnchors + VRC.padding1

        outterCardView.addSubview(cardView)
        cardView.edgeAnchors == outterCardView.edgeAnchors

        ink = MDCInkTouchController(view: outterCardView)
        ink?.addInkView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        separatorInset = UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: 0)
    }

}

