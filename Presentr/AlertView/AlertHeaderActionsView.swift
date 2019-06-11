//
//  AlertHeaderActionsView.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 12/07/18.
//

import UIKit

class AlertHeaderActionsView: AutoSizingStackView {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var actionsView: UIView!
    
    private let priority255 = UILayoutPriority(rawValue: 255)
    private let priority251 = UILayoutPriority(rawValue: 251)
    private let priority258 = UILayoutPriority(rawValue: 258)
    private let priority260 = UILayoutPriority(rawValue: 260)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch (actionsView.intrinsicContentSize.height, headerView.intrinsicContentSize.height) {
        case let (x, y) where x + y < frame.height:
            actionsView.setContentHuggingPriority(priority258, for: .vertical)
            headerView.setContentHuggingPriority(priority260, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority258, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority260, for: .vertical)
        case let (x, y) where x < frame.height / 2 && y > frame.height / 2:
            actionsView.setContentHuggingPriority(priority260, for: .vertical)
            headerView.setContentHuggingPriority(priority258, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority260, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority258, for: .vertical)
        case let (x, y) where y < frame.height / 2 && x > frame.height / 2:
            headerView.setContentHuggingPriority(priority260, for: .vertical)
            actionsView.setContentHuggingPriority(priority258, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority260, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority258, for: .vertical)
        case let (x, y) where x > frame.height / 2 && y > frame.height / 2:
            headerView.setContentHuggingPriority(priority255, for: .vertical)
            actionsView.setContentHuggingPriority(priority251, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority255, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority251, for: .vertical)
        default:
            actionsView.setContentHuggingPriority(priority258, for: .vertical)
            headerView.setContentHuggingPriority(priority260, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority258, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority260, for: .vertical)
        }
    }
}
