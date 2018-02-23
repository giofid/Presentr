//
//  ActionSheetPopoverApperance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

open class ActionSheetPopoverApperance {
    
    
    // MARK: - Initialization
    
    public init(width: CGFloat) {
        self.width = width
    }
    
    public init(copy: ActionSheetPopoverApperance) {
        self.width = copy.width
    }
    
    
    // MARK: - Properties
    
    public var width: CGFloat
}
