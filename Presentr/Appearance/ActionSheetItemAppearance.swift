//
//  ActionSheetItemAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

open class ActionSheetItemAppearance {
    
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(copy: ActionSheetItemAppearance) {
        font = copy.font
        height = copy.height
        separatorInsets = copy.separatorInsets
        textColor = copy.textColor
        tintColor = copy.tintColor
    }
    
    
    // MARK: - Properties
    
    public var font: UIFont?
    public var height: CGFloat = 50
    public var separatorInsets: UIEdgeInsets = .zero
    public var textColor: UIColor?
    public var tintColor: UIColor?
}
