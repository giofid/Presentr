//
//  AlertAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 28/02/18.
//

import UIKit

open class AlertAppearance {
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(copy: AlertAppearance) {
        inheritedBackgroundColor = copy.backgroundColor
        inheritedActionsAxis = copy.actionsAxis
        
        item = AlertItemAppearance(copy: copy.item)
        title = AlertTitleAppearance(copy: copy.title)
        body = AlertBodyAppearance(copy: copy.body)
        activityIndicator = AlertActivityIndicatorAppearance(copy: copy.activityIndicator)
        button = AlertButtonItemAppearance(copy: copy.button)
        defaultButton = AlertDefaultButtonItemAppearance(copy: copy.defaultButton)
        destructiveButton = AlertDestructiveButtonItemAppearance(copy: copy.destructiveButton)
    }
    
    func applyAppearance(_ appearance: AlertAppearance) {
        inheritedBackgroundColor = appearance.backgroundColor
        
        item.applyAppearance(appearance.item)
        title.applyAppearance(appearance.title)
        body.applyAppearance(appearance.body)
        activityIndicator.applyAppearance(appearance.activityIndicator)
        button.applyAppearance(appearance.button)
        defaultButton.applyAppearance(appearance.defaultButton)
        destructiveButton.applyAppearance(appearance.destructiveButton)
    }
    
    // MARK: - Properties
    
    private var customBackgroundColor: UIColor?
    private var inheritedBackgroundColor: UIColor?
    public var backgroundColor: UIColor? {
        get {
            return customBackgroundColor ?? inheritedBackgroundColor
        }
        set {
            customBackgroundColor = newValue
        }
    }
    
    private var customActionsAxis: UILayoutConstraintAxis?
    private var inheritedActionsAxis: UILayoutConstraintAxis = .horizontal
    public var actionsAxis: UILayoutConstraintAxis {
        get {
            return customActionsAxis ?? inheritedActionsAxis
        }
        set {
            customActionsAxis = newValue
        }
    }
    
    public lazy var item: AlertItemAppearance = {
        return AlertItemAppearance()
    }()
    
    public lazy var title: AlertTitleAppearance = {
        return AlertTitleAppearance(copy: item)
    }()
    
    public lazy var body: AlertBodyAppearance = {
        return AlertBodyAppearance(copy: item)
    }()
    
    public lazy var activityIndicator: AlertActivityIndicatorAppearance = {
        return AlertActivityIndicatorAppearance()
    }()
    
    public lazy var button: AlertButtonItemAppearance = {
        let alertButton = AlertButtonItemAppearance(copy: item)
        alertButton.backgroundColor = .white
        alertButton.selectedBackgroundColor = UIColor(red: 237.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        alertButton.textColor = UIColor(red: 45.0/255.0, green: 45.0/255.0, blue: 45.0/255.0, alpha: 1.0)
        return alertButton
    }()
    
    public lazy var defaultButton: AlertDefaultButtonItemAppearance = {
        let alertButton = AlertDefaultButtonItemAppearance(copy: item)
        alertButton.backgroundColor = UIColor(red: 172.0/255.0, green: 34.0/255.0, blue: 42.0/255.0, alpha: 1.0)
        alertButton.selectedBackgroundColor = UIColor(red: 132.0/255.0, green: 23.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        return alertButton
    }()
    
    public lazy var destructiveButton: AlertDestructiveButtonItemAppearance = {
        let alertButton = AlertDestructiveButtonItemAppearance(copy: item)
        alertButton.backgroundColor = .red
        return alertButton
    }()
}
