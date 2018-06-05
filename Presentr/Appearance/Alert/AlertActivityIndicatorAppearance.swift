//
//  AlertActivityIndicatorAppearance.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 05/06/18.
//

import UIKit
import NVActivityIndicatorView

open class AlertActivityIndicatorAppearance {
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(copy: AlertActivityIndicatorAppearance) {
        inheritedColor = copy.color
        inheritedType = copy.type
    }
    
    func applyAppearance(_ appearance: AlertActivityIndicatorAppearance) {
        inheritedColor = appearance.color
        inheritedType = appearance.type
    }
    
    // MARK: - Properties
    
    private var customColor: UIColor?
    private var inheritedColor: UIColor?
    public var color: UIColor {
        get {
            return customColor ?? inheritedColor ?? .darkGray
        }
        set {
            customColor = newValue
        }
    }
    
    private var customType: NVActivityIndicatorType?
    private var inheritedType: NVActivityIndicatorType?
    public var type: NVActivityIndicatorType {
        get {
            return customType ?? inheritedType ?? .circleStrokeSpin
        }
        set {
            customType = newValue
        }
    }
}

