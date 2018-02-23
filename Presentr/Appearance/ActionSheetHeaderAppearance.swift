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
            self.backgroundColor = copy.backgroundColor
            self.detailTextFont = copy.detailTextFont
        }
    }
    
    public var backgroundColor: UIColor?
    public var detailTextFont: UIFont?
}
