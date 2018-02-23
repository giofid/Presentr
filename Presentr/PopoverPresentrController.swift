//
//  PopoverPresentrController.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 19/02/18.
//

import UIKit

class PopoverPresentrController: UIPopoverPresentationController {
    
    private var presentingViewControllerTraitCollection: UITraitCollection?
    
    weak var adaptivePresentationDelegate: AdaptivePresentationDelegate?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        if let delegate = presentedViewController as? AdaptivePresentedControllerDelegate {
            delegate.adjustForPopoverPresentation()
        }
        self.backgroundColor = presentedViewController.view.backgroundColor
    }
    
    override var overrideTraitCollection: UITraitCollection? {
        get {
            let oldHorizontalSizeClass = presentingViewControllerTraitCollection?.horizontalSizeClass
            let oldVerticalSizeClass = presentingViewControllerTraitCollection?.verticalSizeClass
            let newHorizontalSizeClass = presentingViewController.traitCollection.horizontalSizeClass
            let newVerticalSizeClass = presentingViewController.traitCollection.verticalSizeClass
           let shouldNotify = ((oldHorizontalSizeClass == .regular && oldVerticalSizeClass == .regular) && (newHorizontalSizeClass != .regular || newVerticalSizeClass != .regular)) || ((newHorizontalSizeClass == .regular && newVerticalSizeClass == .regular) && (oldHorizontalSizeClass != .regular || oldVerticalSizeClass != .regular))
            if shouldNotify && UIApplication.shared.applicationState != .background {
                adaptivePresentationDelegate?.willTransition(presentationController: self, to: presentingViewController.traitCollection)
            }
            presentingViewControllerTraitCollection = presentingViewController.traitCollection
            return super.overrideTraitCollection
        }
        set {
            super.overrideTraitCollection = newValue
        }
    }
}
