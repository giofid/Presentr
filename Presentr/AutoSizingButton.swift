//
//  AutoSizingButton.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 13/07/18.
//

import UIKit

class AutoSizingButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        let size = titleLabel?.intrinsicContentSize ?? .zero
        return CGSize(width: size.width + titleEdgeInsets.left + titleEdgeInsets.right, height: size.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    }
}
