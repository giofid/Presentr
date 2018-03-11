//
//  AutoSizingView.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 01/03/18.
//

import UIKit

class AutoSizingView: UIView {
    
    override var intrinsicContentSize: CGSize {
        var height = CGFloat(0)
            for view in self.subviews {
                height += view.intrinsicContentSize.height
            }
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }
}
