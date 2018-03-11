//
//  Presentr.swift
//  Presentr
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import Foundation
import UIKit

public enum PresentrConstants {

    public enum Values {
        public static let defaultSideMargin: Float = 30.0
        public static let defaultHeightPercentage: Float = 0.66
    }

    public enum Strings {
        public static let alertTitle = "Alert"
        public static let alertBody = "This is an alert."
    }
}

public enum DismissSwipeDirection {

    case `default`
    case bottom
    case top

}

// MARK: - PresentrDelegate

/**
 The 'PresentrDelegate' protocol defines methods that you use to respond to changes from the 'PresentrController'. All of the methods of this protocol are optional.
 */
@objc public protocol PresentrDelegate {
    /**
     Asks the delegate if it should dismiss the presented controller on the tap of the outer chrome view.

     Use this method to validate requirments or finish tasks before the dismissal of the presented controller.

     After things are wrapped up and verified it may be good to dismiss the presented controller automatically so the user does't have to close it again.

     - parameter keyboardShowing: Whether or not the keyboard is currently being shown by the presented view.
     - returns: False if the dismissal should be prevented, otherwise, true if the dimissal should occur.
     */
    @objc optional func presentrShouldDismiss(keyboardShowing: Bool) -> Bool
}

/// Main Presentr class. This is the point of entry for using the framework.
public class Presentr: NSObject {

    /// This must be set during initialization, but can be changed to reuse a Presentr object.
    public var presentationType: PresentationType

    /// The type of transition animation to be used to present the view controller. This is optional, if not provided the default for each presentation type will be used.
    public var transitionType: TransitionType?

    /// The type of transition animation to be used to dismiss the view controller. This is optional, if not provided transitionType or default value will be used.
    public var dismissTransitionType: TransitionType?

    /// Should the presented controller dismiss on background tap. Default is true.
    public var dismissOnTap = true

    /// Should the presented controller dismiss on Swipe inside the presented view controller. Default is false.
    public var dismissOnSwipe = false

    /// If dismissOnSwipe is true, the direction for the swipe. Default depends on presentation type.
    public var dismissOnSwipeDirection: DismissSwipeDirection = .default

    /// Should the presented controller use animation when dismiss on background tap or swipe. Default is true.
    public var dismissAnimated = true

    open lazy var appearance: PresentrAppearance = {
        return PresentrAppearance(copy: .standard)
    }()
    
    /// How the presented view controller should respond to keyboard presentation.
    public var keyboardTranslationType: KeyboardTranslationType = .none

    /// When a ViewController for context is set this handles what happens to a tap when it is outside the context. True will ignore tap and pass the tap to the background controller, false will handle the tap and dismiss the presented controller. Default is false.
    public var shouldIgnoreTapOutsideContext = false

    /// Uses the ViewController's frame as context for the presentation. Imitates UIModalPresentation.currentContext
    public weak var viewControllerForContext: UIViewController? {
        didSet {
            guard let viewController = viewControllerForContext, let view = viewController.view else {
                contextFrameForPresentation = nil
                return
            }
            let correctedOrigin = view.convert(view.frame.origin, to: nil) // Correct origin in relation to UIWindow
            contextFrameForPresentation = CGRect(x: correctedOrigin.x, y: correctedOrigin.y, width: view.bounds.width, height: view.bounds.height)
        }
    }

    fileprivate var contextFrameForPresentation: CGRect?

    // MARK: Init

    public init(presentationType: PresentationType) {
        self.presentationType = presentationType
    }

    // MARK: Private Methods

    fileprivate var presentingViewController: UIViewController!
    fileprivate var presentedViewController: UIViewController!
    fileprivate var  sourceView: UIView?
    fileprivate var  barButtonItem: UIBarButtonItem?
    
    /**
     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    private func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, animated: Bool, completion: (() -> Void)?) {
        presentedVC.modalPresentationStyle = .custom
        presentedVC.transitioningDelegate = self
        presentingVC.present(presentedVC, animated: animated, completion: completion)
    }
    
    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.
     
     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - sourceView: The view containing the anchor rectangle for the popover.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    fileprivate func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, from sourceView: UIView?, animated: Bool, completion: (() -> Void)?) {
        self.presentedViewController = presentedVC
        self.presentingViewController = presentingVC
        self.sourceView = sourceView
        self.barButtonItem = nil
        presentViewController(presentingViewController: presentingVC, presentedViewController: presentedVC, animated: animated, completion: completion)
    }
    
    /**
     Private method for presenting a view controller, using the custom presentation. Called from the UIViewController extension.
     
     - parameter presentingVC: The view controller which is doing the presenting.
     - parameter presentedVC:  The view controller to be presented.
     - barButtonItem: The bar button item on which to anchor the popover.
     - parameter animated:     Animation boolean.
     - parameter completion:   Completion block.
     */
    fileprivate func presentViewController(presentingViewController presentingVC: UIViewController, presentedViewController presentedVC: UIViewController, from barButtonItem: UIBarButtonItem?, animated: Bool, completion: (() -> Void)?) {
        self.presentedViewController = presentedVC
        self.presentingViewController = presentingVC
        self.barButtonItem = barButtonItem
        self.sourceView = nil
        presentViewController(presentingViewController: presentingVC, presentedViewController: presentedVC, animated: animated, completion: completion)
    }

    fileprivate var transitionForPresent: TransitionType {
        return transitionType ?? presentationType.defaultTransitionType()
    }

    fileprivate var transitionForDismiss: TransitionType {
        return dismissTransitionType ?? transitionType ?? presentationType.defaultTransitionType()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension Presentr: UIViewControllerTransitioningDelegate {

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return presentationController(presented, presenting: source)
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForPresent.animation()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transitionForDismiss.animation()
    }
    
//    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        guard let presentationController = presentedViewController.presentationController as? PresentrController,
//            let interactionController = presentationController.swipeInteractionController,
//            interactionController.interactionInProgress
//            else {
//                return nil
//        }
//        return interactionController
//    }

    // MARK: - Private Helper's

    fileprivate func presentationController(_ presented: UIViewController, presenting: UIViewController?) -> UIPresentationController {
        switch presented {
        case let actionSheetController as ActionSheetController:
            actionSheetController.appearance.applyAppearance(appearance.actionSheet)
        case let alertViewController as AlertViewController:
            alertViewController.appearance.applyAppearance(appearance.alert)
        default:
            break
        }
        if presentationType.shouldAdaptPresentationStyle && presenting?.traitCollection.horizontalSizeClass == .regular &&  presenting?.traitCollection.verticalSizeClass == .regular {
            let popoverPresentrController = PopoverPresentrController(presentedViewController: presented, presenting: presenting)
            popoverPresentrController.adaptivePresentationDelegate = self
            popoverPresentrController.sourceView = sourceView
            popoverPresentrController.barButtonItem = barButtonItem
            popoverPresentrController.sourceRect = sourceView?.bounds ?? CGRect()
            return popoverPresentrController
        } else {
            let presentrController = PresentrController(presentedViewController: presented,
                                                        presentingViewController: presenting,
                                                        presentationType: presentationType,
                                                        appearance: appearance,
                                                        dismissOnTap: dismissOnTap,
                                                        dismissOnSwipe: dismissOnSwipe,
                                                        dismissOnSwipeDirection: dismissOnSwipeDirection,
                                                        keyboardTranslationType:  keyboardTranslationType,
                                                        dismissAnimated: dismissAnimated,
                                                        contextFrameForPresentation: contextFrameForPresentation,
                                                        shouldIgnoreTapOutsideContext: shouldIgnoreTapOutsideContext)
            presentrController.adaptivePresentationDelegate = self
            return presentrController
        }
    }
}

extension Presentr: AdaptivePresentationDelegate {
    func willTransition(presentationController: UIPresentationController, to newCollection: UITraitCollection) {
        presentedViewController.dismiss(animated: false) {
            if let sourceView = self.sourceView {
                self.presentViewController(presentingViewController: self.presentingViewController, presentedViewController: self.presentedViewController, from: sourceView, animated: false, completion: nil)
            } else {
                self.presentViewController(presentingViewController: self.presentingViewController, presentedViewController: self.presentedViewController, from: self.barButtonItem, animated: false, completion: nil)
            }
        }
    }
}

// MARK: - UIViewController extension to provide customPresentViewController(_:viewController:animated:completion:) method


public extension UIViewController {
    
    /// Present a view controller with a custom presentation provided by the Presentr object.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to be presented.
    ///   - presentr: Presentr object used for custom presentation.
    ///   - sourceView: The view containing the anchor rectangle for the popover.
    ///   - animated: Animation setting for the presentation.
    ///   - completion: Completion handler.
    func customPresent(_ viewControllerToPresent: UIViewController, presentr: Presentr, from sourceView: UIView? = nil, animated: Bool, completion: (() -> Void)? = nil) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewControllerToPresent,
                                       from: sourceView,
                                       animated: animated,
                                       completion: completion)
    }
    
    /// Present a view controller with a custom presentation provided by the Presentr object.
    ///
    /// - Parameters:
    ///   - viewControllerToPresent: The view controller to be presented.
    ///   - presentr: Presentr object used for custom presentation.
    ///   - barButtonItem: The bar button item on which to anchor the popover.
    ///   - animated: Animation setting for the presentation.
    ///   - completion: Completion handler.
    func customPresent(_ viewControllerToPresent: UIViewController, presentr: Presentr, from barButtonItem: UIBarButtonItem, animated: Bool, completion: (() -> Void)? = nil) {
        presentr.presentViewController(presentingViewController: self,
                                       presentedViewController: viewControllerToPresent,
                                       from: barButtonItem,
                                       animated: animated,
                                       completion: completion)
    }
}
