//
//  ActionSheetTitleAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

open class ActionSheetTitleAppearance: ActionSheetItemAppearance {
    
    public override init(copy: ActionSheetItemAppearance) {
        super.init(copy: copy)
        if let copy = copy as? ActionSheetTitleAppearance {
            self.inheritedMessageTextFont = copy.messageTextFont
        }
    }
    
    override func applyAppearance(_ appearance: ActionSheetItemAppearance) {
        super.applyAppearance(appearance)
        if let appearance = appearance as? ActionSheetTitleAppearance {
            self.inheritedMessageTextFont = appearance.messageTextFont
        }
    }
    
    private var customMessageTextFont: UIFont?
    private var inheritedMessageTextFont: UIFont?
    public var messageTextFont: UIFont? {
        get {
            return customMessageTextFont ?? inheritedMessageTextFont
        }
        set {
            customMessageTextFont = newValue
        }
    }
}
