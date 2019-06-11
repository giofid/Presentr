//
//  AdaptivePresentedControllerDelegate.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 20/02/18.
//

import UIKit

protocol AdaptivePresentedControllerDelegate: NSObjectProtocol {

    func adjustForPopoverPresentation()
    
    func adjustForStandardPresentation()
}
