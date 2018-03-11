//
//  PresentrAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 2018-02-22.
//

/*
 
 This class is used to specify the appearance for all views provided by Presentr. Use
 `PresentrAppearance.standard` to style all view
 in an entire app. You can then apply individual appearances
 to individual views and item types.
 
 The `item` appearance property is used as the base template
 for all other item appearances.
 
 */

import UIKit

open class PresentrAppearance {
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(copy: PresentrAppearance) {
        roundCorners = copy.roundCorners
        cornerRadius = copy.cornerRadius
        contentInset = copy.contentInset
        backgroundColor = copy.backgroundColor
        dropShadow = copy.dropShadow
        backgroundOpacity = copy.backgroundOpacity
        blurBackground = copy.blurBackground
        blurStyle = copy.blurStyle
        customBackgroundView = copy.customBackgroundView
        
        actionSheet = ActionSheetAppearance(copy: copy.actionSheet)
        alert = AlertAppearance(copy: copy.alert)
    }
    
    // MARK: - Properties
    
    /// Should the presented controller have rounded corners. Each presentation type has its own default if nil.
    public var roundCorners: Bool? {
        didSet {
            actionSheet.roundCorners = roundCorners
        }
    }
    
    /// Radius of rounded corners for presented controller if roundCorners is true. Default is 4.
    public var cornerRadius: CGFloat = 4 {
        didSet {
            actionSheet.cornerRadius = cornerRadius
        }
    }
    
    public var contentInset: CGFloat = 15 {
        didSet {
            actionSheet.contentInset = contentInset
        }
    }
    
    /// Shadow settings for presented controller.
    public var dropShadow: PresentrShadow?
    
    /// Color of the background. Default is Black.
    public var backgroundColor = UIColor.black
    
    /// Opacity of the background. Default is 0.7.
    public var backgroundOpacity: Float = 0.7
    
    /// Should the presented controller blur the background. Default is false.
    public var blurBackground = false
    
    /// The type of blur to be applied to the background. Ignored if blurBackground is set to false. Default is Dark.
    public var blurStyle: UIBlurEffectStyle = .dark
    
    /// A custom background view to be added on top of the regular background view.
    public var customBackgroundView: UIView?
    
    // MARK: - Appearance Properties
    
    public static var standard = PresentrAppearance()
    
    public lazy var actionSheet: ActionSheetAppearance = {
        return ActionSheetAppearance(roundCorners: roundCorners, cornerRadius: cornerRadius, contentInset: contentInset)
    }()
    
    public lazy var alert: AlertAppearance = {
        return AlertAppearance()
    }()
}
