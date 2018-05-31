//
//  PaddingUITextField.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 29/05/18.
//

import UIKit

@IBDesignable class PaddingUITextField: UITextField {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0
    @IBInspectable var rightInset: CGFloat = 0
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(topInset, leftInset, bottomInset, rightInset))
    }
}
