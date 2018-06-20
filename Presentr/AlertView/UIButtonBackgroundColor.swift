//
//  UIButtonBackgroundColor.swift
//  ArubaMobileOTP
//
//  Created by Giorgio Fiderio on 10/11/15.
//  Copyright © 2015 Giorgio Fiderio - eSecurity. All rights reserved.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, forState state: UIControlState) {
        let image = color != nil ? UIImage.imageColored(color!) : nil
        setBackgroundImage(image, for: state)
    }
}

extension UIImage {
    
    class func imageColored(_ color: UIColor) -> UIImage? {
        let onePixel = 1 / UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, color.cgColor.alpha == 1, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
