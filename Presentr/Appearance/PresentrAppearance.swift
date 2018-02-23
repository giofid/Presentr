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
        
        cancelButton = ActionSheetCancelButtonAppearance(copy: copy.cancelButton)
        dangerButton = ActionSheetDangerButtonAppearance(copy: copy.dangerButton)
        item = ActionSheetItemAppearance(copy: copy.item)
        header = ActionSheetHeaderAppearance(copy: copy.header)
        okButton = ActionSheetOkButtonAppearance(copy: copy.okButton)
        popover = ActionSheetPopoverApperance(copy: copy.popover)
        sectionTitle = ActionSheetSectionTitleAppearance(copy: copy.sectionTitle)
        title = ActionSheetTitleAppearance(copy: copy.title)
    }
    
    // MARK: - Properties
    
    /// Should the presented controller have rounded corners. Each presentation type has its own default if nil.
    public var roundCorners: Bool?
    
    /// Radius of rounded corners for presented controller if roundCorners is true. Default is 4.
    public var cornerRadius: CGFloat = 4
//    public var cornerRadius: CGFloat = 10
    
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
    
    public var contentInset: CGFloat = 15
    
    // MARK: - Appearance Properties
    
    public static var standard = PresentrAppearance()
    
    public lazy var cancelButton: ActionSheetCancelButtonAppearance = {
        return ActionSheetCancelButtonAppearance(copy: item)
    }()
    
    public lazy var dangerButton: ActionSheetDangerButtonAppearance = {
        let appearance = ActionSheetDangerButtonAppearance(copy: item)
        appearance.textColor = .red
        return appearance
    }()
    
    public lazy var header: ActionSheetHeaderAppearance = {
        return ActionSheetHeaderAppearance(copy: item)
    }()
    
    public lazy var item: ActionSheetItemAppearance = {
        return ActionSheetItemAppearance()
    }()
    
    public lazy var okButton: ActionSheetOkButtonAppearance = {
        return ActionSheetOkButtonAppearance(copy: item)
    }()
    
    public lazy var popover: ActionSheetPopoverApperance = {
        return ActionSheetPopoverApperance(width: 300)
    }()
    
    public lazy var sectionTitle: ActionSheetSectionTitleAppearance = {
        return ActionSheetSectionTitleAppearance(copy: item)
    }()
    
    public lazy var title: ActionSheetTitleAppearance = {
        return ActionSheetTitleAppearance(copy: item)
    }()
}
