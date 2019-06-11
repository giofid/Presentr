//
//  ActionSheetAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 10/03/18.
//

import UIKit

open class ActionSheetAppearance {
    
    // MARK: - Initialization
    
    init(roundCorners: Bool?, cornerRadius: CGFloat, contentInset: CGFloat) {
        self.roundCorners = roundCorners
        self.cornerRadius = cornerRadius
        self.contentInset = contentInset
    }
    
    public init(copy: ActionSheetAppearance) {
        roundCorners = copy.roundCorners
        cornerRadius = copy.cornerRadius
        contentInset = copy.contentInset
        
        item = ActionSheetItemAppearance(copy: copy.item)
        header = ActionSheetHeaderAppearance(copy: copy.header)
        title = ActionSheetTitleAppearance(copy: copy.title)
    }
    
    func applyAppearance(_ appearance: ActionSheetAppearance) {
        roundCorners = appearance.roundCorners
        cornerRadius = appearance.cornerRadius
        contentInset = appearance.contentInset
        
        item.applyAppearance(appearance.item)
        title.applyAppearance(appearance.title)
        header.applyAppearance(appearance.header)
    }
    
    // MARK: - Properties
    
    /// Should the presented controller have rounded corners. Each presentation type has its own default if nil.
    internal var roundCorners: Bool?

    /// Radius of rounded corners for presented controller if roundCorners is true. Default is 4.
    internal var cornerRadius: CGFloat = 4
    
    internal var contentInset: CGFloat = 15
    
    // MARK: - Appearance Properties
    
    public lazy var header: ActionSheetHeaderAppearance = {
        return ActionSheetHeaderAppearance(copy: item)
    }()
    
    public lazy var item: ActionSheetItemAppearance = {
        return ActionSheetItemAppearance()
    }()
    
    public lazy var title: ActionSheetTitleAppearance = {
        return ActionSheetTitleAppearance(copy: item)
    }()
}
