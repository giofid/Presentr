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
        
        item = copy.item
        title = copy.title
        body = copy.body
        activityIndicator = copy.activityIndicator
        button = copy.button
        defaultButton = copy.defaultButton
    }
    
    func applyAppearance(_ appearance: AlertAppearance) {
        inheritedBackgroundColor = appearance.backgroundColor
        
        item.applyAppearance(appearance.item)
        title.applyAppearance(appearance.title)
        body.applyAppearance(appearance.body)
        activityIndicator.applyAppearance(appearance.activityIndicator)
        button.applyAppearance(appearance.button)
        defaultButton.applyAppearance(appearance.defaultButton)
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
        return alertButton
    }()
    
    public lazy var defaultButton: AlertDefaultButtonItemAppearance = {
        let alertButton = AlertDefaultButtonItemAppearance(copy: item)
        alertButton.backgroundColor = .white
        return alertButton
    }()
}
