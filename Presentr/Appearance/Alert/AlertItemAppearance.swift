//
//  AlertItemAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 28/02/18.
//

import UIKit

open class AlertItemAppearance {
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(copy: AlertItemAppearance) {
        inheritedFont = copy.font
        inheritedTextColor = copy.textColor
    }
    
    func applyAppearance(_ appearance: AlertItemAppearance) {
        inheritedFont = appearance.font
        inheritedTextColor = appearance.textColor
    }
    
    // MARK: - Properties
    
    private var customFont: UIFont?
    private var inheritedFont: UIFont?
    public var font: UIFont? {
        get {
            return customFont ?? inheritedFont
        }
        set {
            customFont = newValue
        }
    }
    
    private var customTextColor: UIColor?
    private var inheritedTextColor: UIColor?
    public var textColor: UIColor? {
        get {
            return customTextColor ?? inheritedTextColor
        }
        set {
            customTextColor = newValue
        }
    }
}
