//
//  AutoSizingScrollView.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 27/02/18.
//

import UIKit

class AutoSizingScrollView: UIScrollView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
