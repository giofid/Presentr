//
//  CustomView.swift
//  PresentrExample
//
//  Created by Giorgio Fiderio on 25/02/2019.
//  Copyright © 2019 danielozano. All rights reserved.
//

import UIKit
import Presentr

class CustomView: UIView {
    
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var arubaCallButton: UIButton!
    @IBOutlet weak var smsButton: UIButton!
    
    @IBOutlet weak var otpView: UIView!
    @objc func handleTap() {
        print("ciao")
    }
    
    @objc func handleTouchUpInside() {
        print("handleTouchUpInside")
        self.otpButton.sendActions(for: .touchUpInside)
        self.otpButton.isHighlighted = false
    }
    
    @objc func handleTouchUpOutside() {
        print("handleTouchUpOutside")
        self.otpButton.sendActions(for: .touchUpOutside)
        self.otpButton.isHighlighted = false
    }
    
    @objc func handleTouchCancel() {
        print("handleTouchCancel")
        self.otpButton.sendActions(for: .touchCancel)
        self.otpButton.isHighlighted = false
    }
    
    @objc func handleTouchDown() {
        print("handleTouchDown")
        self.otpButton.sendActions(for: .touchDown)
        self.otpButton.isHighlighted = true
    }
    
    func loadNib() -> CustomView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! CustomView
    }
}
