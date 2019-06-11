//
//  ActionSheetHeaderAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

open class ActionSheetHeaderAppearance: ActionSheetItemAppearance {
    
    public override init(copy: ActionSheetItemAppearance) {
        super.init(copy: copy)
        if let copy = copy as? ActionSheetHeaderAppearance {
            self.inheritedBackgroundColor = copy.backgroundColor
            self.inheritedDetailTextFont = copy.detailTextFont
        }
    }
    
    override func applyAppearance(_ appearance: ActionSheetItemAppearance) {
        super.applyAppearance(appearance)
        if let appearance = appearance as? ActionSheetHeaderAppearance {
            self.inheritedBackgroundColor = appearance.backgroundColor
            self.inheritedDetailTextFont = appearance.detailTextFont
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
    
    private var customDetailTextFont: UIFont?
    private var inheritedDetailTextFont: UIFont?
    public var detailTextFont: UIFont? {
        get {
            return customDetailTextFont ?? inheritedDetailTextFont
        }
        set {
            customDetailTextFont = newValue
        }
    }
}
