//
//  ActionSheetHeaderActionsView.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 13/07/18.
//

import UIKit

class ActionSheetHeaderActionsView: AutoSizingStackView {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var actionsView: UIView!
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    
    private let priority253 = UILayoutPriority(rawValue: 253)
    private let priority251 = UILayoutPriority(rawValue: 251)
    private let priority255 = UILayoutPriority(rawValue: 255)
    
     override func layoutSubviews() {
        super.layoutSubviews()
        switch (actionsView.intrinsicContentSize.height, headerView.intrinsicContentSize.height) {
        case let (x, y) where x < frame.height / 2 && y > frame.height / 2:
            actionsView.setContentHuggingPriority(priority253, for: .vertical)
            headerView.setContentHuggingPriority(priority251, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority255, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority253, for: .vertical)
        case let (x, y) where y < frame.height / 2 && x > frame.height / 2:
            headerView.setContentHuggingPriority(priority253, for: .vertical)
            actionsView.setContentHuggingPriority(priority251, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority255, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority253, for: .vertical)
        case let (x, y) where x > frame.height / 2 && y > frame.height / 2:
            headerView.setContentHuggingPriority(priority253, for: .vertical)
            actionsView.setContentHuggingPriority(priority251, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority255, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority253, for: .vertical)
        default:
            break
        }
    }
}

