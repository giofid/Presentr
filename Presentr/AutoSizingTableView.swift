//
//  AutoSizingTableView.swift
//  PresentrExample
//
//  Created by Giorgio Fiderio on 15/02/18.
//  Copyright © 2018 danielozano. All rights reserved.
//

import UIKit

class AutoSizingTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
}
