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
        inheritedFont = copy.font
        inheritedHeight = copy.height
        inheritedSeparatorInsets = copy.separatorInsets
        inheritedShouldShowSeparator = copy.shouldShowSeparator
        inheritedTextColor = copy.textColor
        inheritedTintColor = copy.tintColor
        inheritedTextAlignment = copy.textAlignment
    }
    
    func applyAppearance(_ appearance: ActionSheetItemAppearance) {
        inheritedFont = appearance.font
        inheritedHeight = appearance.height
        inheritedSeparatorInsets = appearance.separatorInsets
        inheritedShouldShowSeparator = appearance.shouldShowSeparator
        inheritedTextColor = appearance.textColor
        inheritedTintColor = appearance.tintColor
        inheritedTextAlignment = appearance.textAlignment
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
   
    private var customHeight: CGFloat?
    private var inheritedHeight: CGFloat = 50
    public var height: CGFloat {
        get {
            return customHeight ?? inheritedHeight
        }
        set {
            customHeight = newValue
        }
    }
    
    private var customShouldShowSeparator: Bool?
    private var inheritedShouldShowSeparator: Bool = false
    public var shouldShowSeparator: Bool {
        get {
            return customShouldShowSeparator ?? inheritedShouldShowSeparator
        }
        set {
            customShouldShowSeparator = newValue
        }
    }
    
    private var customSeparatorInsets: UIEdgeInsets?
    private var inheritedSeparatorInsets: UIEdgeInsets = .zero
    public var separatorInsets: UIEdgeInsets {
        get {
            return customSeparatorInsets ?? inheritedSeparatorInsets
        }
        set {
            customSeparatorInsets = newValue
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
    
    private var customTintColor: UIColor?
    private var inheritedTintColor: UIColor?
    public var tintColor: UIColor? {
        get {
            return customTintColor ?? inheritedTintColor
        }
        set {
            customTintColor = newValue
        }
    }
    
    private var customTextAlignment: NSTextAlignment?
    private var inheritedTextAlignment: NSTextAlignment = .natural
    public var textAlignment: NSTextAlignment {
        get {
            return customTextAlignment ?? inheritedTextAlignment
        }
        set {
            customTextAlignment = newValue
        }
    }
}
