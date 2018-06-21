//
//  AlertButtonItemAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 28/02/18.
//

import UIKit

open class AlertButtonItemAppearance: AlertItemAppearance {
    
    public override init(copy: AlertItemAppearance) {
        super.init(copy: copy)
        if let copy = copy as? AlertButtonItemAppearance {
            self.inheritedCornerRadius = copy.cornerRadius
            self.inheritedBorderColor = copy.borderColor
             self.inheritedBorderWidth = copy.borderWidth
            self.inheritedBackgroundColor = copy.backgroundColor
            self.inheritedSelectedBackgroundColor = copy.selectedBackgroundColor
            self.inheritedMinimumScaleFactor = copy.minimumScaleFactor
        }
    }
    
    override func applyAppearance(_ appearance: AlertItemAppearance) {
        super.applyAppearance(appearance)
        if let appearance = appearance as? AlertButtonItemAppearance {
            self.inheritedCornerRadius = appearance.cornerRadius
            self.inheritedBorderColor = appearance.borderColor
            self.inheritedBorderWidth = appearance.borderWidth
            self.inheritedBackgroundColor = appearance.backgroundColor
            self.inheritedSelectedBackgroundColor = appearance.selectedBackgroundColor
            self.inheritedMinimumScaleFactor = appearance.minimumScaleFactor
        }
    }
    
    private var customCornerRadius: CGFloat?
    private var inheritedCornerRadius: CGFloat?
    public var cornerRadius: CGFloat? {
        get {
            return customCornerRadius ?? inheritedCornerRadius
        }
        set {
            customCornerRadius = newValue
        }
    }
    
    private var customBorderColor: UIColor?
    private var inheritedBorderColor: UIColor?
    public var borderColor: UIColor? {
        get {
            return customBorderColor ?? inheritedBorderColor
        }
        set {
            customBorderColor = newValue
        }
    }
    
    private var customBorderWidth: CGFloat?
    private var inheritedBorderWidth: CGFloat?
    public var borderWidth: CGFloat? {
        get {
            return customBorderWidth ?? inheritedBorderWidth
        }
        set {
            customBorderWidth = newValue
        }
    }
    
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
    
    private var customSelectedBackgroundColor: UIColor?
    private var inheritedSelectedBackgroundColor: UIColor?
    public var selectedBackgroundColor: UIColor? {
        get {
            return customSelectedBackgroundColor ?? inheritedSelectedBackgroundColor
        }
        set {
            customSelectedBackgroundColor = newValue
        }
    }
    
    private var customMinimumScaleFactor: CGFloat?
    private var inheritedMinimumScaleFactor: CGFloat?
    public var minimumScaleFactor: CGFloat? {
        get {
            return customMinimumScaleFactor ?? inheritedMinimumScaleFactor
        }
        set {
            customMinimumScaleFactor = newValue
        }
    }
}
