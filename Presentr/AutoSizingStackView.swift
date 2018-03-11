//
//  AutoSizingStackView.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 20/02/18.
//

import UIKit

class AutoSizingStackView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        switch axis {
        case .horizontal:
            var width = CGFloat(0)
            for view in self.arrangedSubviews {
                width += view.intrinsicContentSize.width + spacing
            }
            return CGSize(width: width - spacing, height: UIViewNoIntrinsicMetric)
        case .vertical:
            var height = CGFloat(0)
            for view in self.arrangedSubviews {
                height += view.intrinsicContentSize.height + spacing
            }
            return CGSize(width: UIViewNoIntrinsicMetric, height: height - spacing)
        }
    }
}