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
            self.inheritedBackgroundColor = copy.backgroundColor
        }
    }
    
    override func applyAppearance(_ appearance: AlertItemAppearance) {
        super.applyAppearance(appearance)
        if let appearance = appearance as? AlertButtonItemAppearance {
            self.inheritedBackgroundColor = appearance.backgroundColor
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
}
