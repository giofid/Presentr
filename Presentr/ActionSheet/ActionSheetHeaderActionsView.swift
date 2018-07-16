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
    
    private let priority255 = UILayoutPriority(rawValue: 255)
    private let priority253 = UILayoutPriority(rawValue: 253)
    private let priority251 = UILayoutPriority(rawValue: 251)
    private let priority258 = UILayoutPriority(rawValue: 258)
    private let priority260 = UILayoutPriority(rawValue: 260)
    
    private let priority755 = UILayoutPriority(rawValue: 755)
    private let priority753 = UILayoutPriority(rawValue: 753)
    private let priority751 = UILayoutPriority(rawValue: 751)
    private let priority758 = UILayoutPriority(rawValue: 758)
    private let priority760 = UILayoutPriority(rawValue: 760)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch (actionsView.intrinsicContentSize.height, headerView.intrinsicContentSize.height) {
        case let (x, y) where x < frame.height / 2 && y > frame.height / 2:
            actionsView.setContentHuggingPriority(priority260, for: .vertical)
            headerView.setContentHuggingPriority(priority258, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority260, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority258, for: .vertical)
        case let (x, y) where y < frame.height / 2 && x > frame.height / 2:
            headerView.setContentHuggingPriority(priority255, for: .vertical)
            actionsView.setContentHuggingPriority(priority251, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority255, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority251, for: .vertical)
        case let (x, y) where x > frame.height / 2 && y > frame.height / 2:
            headerView.setContentHuggingPriority(priority255, for: .vertical)
            actionsView.setContentHuggingPriority(priority251, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority255, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority251, for: .vertical)
        default:
            actionsView.setContentHuggingPriority(priority260, for: .vertical)
            headerView.setContentHuggingPriority(priority258, for: .vertical)
            actionsView.setContentCompressionResistancePriority(priority260, for: .vertical)
            headerView.setContentCompressionResistancePriority(priority258, for: .vertical)
        }
    }
}

