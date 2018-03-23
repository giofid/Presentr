//
//  PresentrPresentationController.swift
//  OneUP
//
//  Created by Daniel Lozano on 4/27/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

protocol AdaptivePresentationDelegate: NSObjectProtocol {
    func willTransition(presentationController: UIPresentationController,to newCollection: UITraitCollection)
}

/// Presentr's custom presentation controller. Handles the position and sizing for the view controller's.
class PresentrController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    /// Presentation type must be passed in to make all the sizing and position decisions.
    let presentationType: PresentationType

    /// Should the presented controller dismiss on background tap.
    let dismissOnTap: Bool
    
    /// Should the presented controller dismiss on background Swipe.
    let dismissOnSwipe: Bool

    /// DismissSwipe direction
    let dismissOnSwipeDirection: DismissSwipeDirection
    
    /// Should the presented controller use animation when dismiss on background tap.
    let dismissAnimated: Bool

    /// How the presented view controller should respond in response to keyboard presentation.
    let keyboardTranslationType: KeyboardTranslationType

    /// The frame used for a current context presentation. If nil, normal presentation.
    let contextFrameForPresentation: CGRect?

    /// If contextFrameForPresentation is set, this handles what happens when tap outside context frame.
    let shouldIgnoreTapOutsideContext: Bool

    /// A custom background view to be added on top of the regular background view.
    let customBackgroundView: UIView?
    
    /// A custom background view to be added on top of the regular background view.
    let contentInset: CGFloat
    
    weak var adaptivePresentationDelegate: AdaptivePresentationDelegate?

    fileprivate var conformingPresentedController: PresentrDelegate? {
        return presentedViewController as? PresentrDelegate
    }

    fileprivate var shouldObserveKeyboard: Bool {
        return conformingPresentedController != nil ||
            (keyboardTranslationType != .none && presentationType == .popup) // TODO: Work w/other types?
    }

    fileprivate var containerFrame: CGRect {
        return contextFrameForPresentation ?? containerView?.bounds ?? CGRect()
    }

    fileprivate var keyboardIsShowing: Bool = false

    // MARK: Background Views

    fileprivate var chromeView = UIView()

    fileprivate var backgroundView = PassthroughBackgroundView()

    fileprivate var visualEffect: UIVisualEffect?

    // MARK: Swipe gesture

    fileprivate var presentedViewFrame: CGRect = .zero

    fileprivate var presentedViewCenter: CGPoint = .zero

    fileprivate var latestShouldDismiss: Bool = true

    fileprivate lazy var shouldSwipeBottom: Bool = {
        return self.dismissOnSwipeDirection == .default ? self.presentationType != .topHalf : self.dismissOnSwipeDirection == .bottom
    }()

    fileprivate lazy var shouldSwipeTop: Bool = {
        return self.dismissOnSwipeDirection == .default ? self.presentationType == .topHalf : self.dismissOnSwipeDirection == .top
    }()
    
    fileprivate var closeSpeed: CGFloat = 0.0
    fileprivate var closePercent: CGFloat = 0.0
    
    var pannedHeight: CGFloat = 0

    // MARK: - Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentationType: PresentationType,
         appearance: PresentrAppearance,
         dismissOnTap: Bool,
         dismissOnSwipe: Bool,
         dismissOnSwipeDirection: DismissSwipeDirection,
         keyboardTranslationType: KeyboardTranslationType,
         dismissAnimated: Bool,
         contextFrameForPresentation: CGRect?,
         shouldIgnoreTapOutsideContext: Bool) {

        self.presentationType = presentationType
        self.dismissOnTap = dismissOnTap
        self.dismissOnSwipe = dismissOnSwipe
        self.dismissOnSwipeDirection = dismissOnSwipeDirection
        self.keyboardTranslationType = keyboardTranslationType
        self.dismissAnimated = dismissAnimated
        self.contextFrameForPresentation = contextFrameForPresentation
        self.shouldIgnoreTapOutsideContext = shouldIgnoreTapOutsideContext
        self.customBackgroundView = appearance.customBackgroundView
        self.contentInset = appearance.contentInset

        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        if let delegate = presentedViewController as? AdaptivePresentedControllerDelegate {
            delegate.adjustForStandardPresentation()
        }
        
        setupBackground(appearance.backgroundColor, backgroundOpacity: appearance.backgroundOpacity, blurBackground: appearance.blurBackground, blurStyle: appearance.blurStyle)
        setupCornerRadius(roundCorners: appearance.roundCorners, cornerRadius: appearance.cornerRadius)
        addDropShadow(shadow: appearance.dropShadow)
        
        if dismissOnSwipe {
            setupDismissOnSwipe()
        }

        if shouldObserveKeyboard {
            registerKeyboardObserver()
        }
    }

    // MARK: - Setup

    private func setupDismissOnSwipe() {
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
        swipe.delegate = self
        presentedViewController.view.addGestureRecognizer(swipe)
        addPanGestureToScrollableSubviews(of: presentedViewController.view)
    }
    
    private func addPanGestureToScrollableSubviews(of view: UIView) {
        let subviews = view.subviews
        for v in subviews {
            if v is UIScrollView {
                let panGesture = UIPanGestureRecognizer()
                panGesture.delegate = self
                v.addGestureRecognizer(panGesture)
                continue
            }
            addPanGestureToScrollableSubviews(of: v)
        }
    }
    
    private func setupBackground(_ backgroundColor: UIColor, backgroundOpacity: Float, blurBackground: Bool, blurStyle: UIBlurEffectStyle) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        tap.delaysTouchesBegan = true
        chromeView.addGestureRecognizer(tap)

        if !shouldIgnoreTapOutsideContext {
            let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
             tap.delaysTouchesBegan = true
            backgroundView.addGestureRecognizer(tap)
        }

        if blurBackground {
            visualEffect = UIBlurEffect(style: blurStyle)
        } else {
            chromeView.backgroundColor = backgroundColor.withAlphaComponent(CGFloat(backgroundOpacity))
        }
    }

    private func setupCornerRadius(roundCorners: Bool?, cornerRadius: CGFloat) {
        let shouldRoundCorners = roundCorners ?? presentationType.shouldRoundCorners
        if shouldRoundCorners {
            presentedViewController.view.layer.cornerRadius = cornerRadius
            presentedViewController.view.layer.masksToBounds = true
        } else {
            presentedViewController.view.layer.cornerRadius = 0
        }
    }
    
    private func addDropShadow(shadow: PresentrShadow?) {
        guard let shadow = shadow else {
            presentedViewController.view.layer.masksToBounds = true
            presentedViewController.view.layer.shadowOpacity = 0
            return
        }

        presentedViewController.view.layer.masksToBounds = false
        if let shadowColor = shadow.shadowColor?.cgColor {
            presentedViewController.view.layer.shadowColor = shadowColor
        }
        if let shadowOpacity = shadow.shadowOpacity {
            presentedViewController.view.layer.shadowOpacity = shadowOpacity
        }
        if let shadowOffset = shadow.shadowOffset {
            presentedViewController.view.layer.shadowOffset = shadowOffset
        }
        if let shadowRadius = shadow.shadowRadius {
            presentedViewController.view.layer.shadowRadius = shadowRadius
        }
    }
    
    fileprivate func registerKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWasShown(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PresentrController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    private var presentingViewControllerTraitCollection: UITraitCollection?
    
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

// MARK: - UIPresentationController

extension PresentrController {
    
    // MARK: Presentation
    
    override var shouldPresentInFullscreen: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerFrame
        let size = self.size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        
        let origin: CGPoint
        // If the Presentation Type's calculate center point returns nil
        // this means that the user provided the origin, not a center point.
        if let center = getCenterPointFromType(size: size) {
            origin = calculateOrigin(center, size: size)
        } else {
            origin = getOriginFromType() ?? CGPoint(x: 0, y: 0)
        }
        
        presentedViewFrame.size = size
        presentedViewFrame.origin = origin
        
        return presentedViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        let width = getWidthFromType(parentSize)
        let height = getHeightFromType(parentSize)
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    override func containerViewWillLayoutSubviews() {
        guard !keyboardIsShowing else {
            return // prevent resetting of presented frame when the frame is being translated
        }
        chromeView.frame = containerFrame
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    // MARK: Animation
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }

        setupBackgroundView()

        backgroundView.frame = containerView.bounds
        chromeView.frame = containerFrame

        containerView.insertSubview(backgroundView, at: 0)
        containerView.insertSubview(chromeView, at: 1)

        if let customBackgroundView = customBackgroundView {
            chromeView.addSubview(customBackgroundView)
        }

        var blurEffectView: UIVisualEffectView?
        if visualEffect != nil {
            let view = UIVisualEffectView()
            view.frame = chromeView.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            chromeView.insertSubview(view, at: 0)
            blurEffectView = view
        } else {
            chromeView.alpha = 0.0
        }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: { context in
            blurEffectView?.effect = self.visualEffect
            self.chromeView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 0.0
            return
        }

        coordinator.animate(alongsideTransition: { context in
            self.chromeView.alpha = 0.0
        }, completion: nil)
    }

    // MARK: - Animation Helper's

    func setupBackgroundView() {
        if shouldIgnoreTapOutsideContext {
            backgroundView.shouldPassthrough = true
            backgroundView.passthroughViews = presentingViewController.view.subviews
        } else {
            backgroundView.shouldPassthrough = false
            backgroundView.passthroughViews = []
        }
    }
}

// MARK: - Sizing, Position

fileprivate extension PresentrController {

    func getWidthFromType(_ parentSize: CGSize) -> Float {
        guard let size = presentationType.size() else {
            if case .dynamic(let modalCenterPosition) = presentationType {
                if case .bottom(_ , let fixedWidth) = modalCenterPosition {
                    if fixedWidth {
                        return Float(min(parentSize.width, parentSize.height) -  contentInset * 2)
                    } else {
                        return Float(parentSize.width - contentInset * 2)
                    }
                } else {
                    presentedViewController.view.layoutIfNeeded()
                    return Float(presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width)
                }
            }
            return 0
        }
        
        return size.width.calculateWidth(parentSize)
    }
    
    func getHeightFromType(_ parentSize: CGSize) -> Float {
        guard let size = presentationType.size() else {
            if case .dynamic(let modalCenterPosition) = presentationType {
                presentedViewController.view.layoutIfNeeded()
                let height = presentedViewController.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
                if case .bottom(let percentage, _) = modalCenterPosition {
                    return Float(min(parentSize.height * CGFloat(percentage), height + (contentInset != 0 ? 0 : pannedHeight), parentSize.height - (contentInset * 2)))
                } else {
                    return Float(min(height, height + (contentInset != 0 ? 0 : pannedHeight), parentSize.height - (contentInset * 2)))
                }
             }
            return 0
        }
        return size.height.calculateHeight(parentSize)
    }

    func getCenterPointFromType(size: CGSize) -> CGPoint? {
        let containerBounds = containerFrame
        let position = presentationType.position()
        return position.calculateCenterPoint(containerBounds, size: size, contentInset: contentInset)
    }

    func getOriginFromType() -> CGPoint? {
        let position = presentationType.position()
        return position.calculateOrigin()
    }

    func calculateOrigin(_ center: CGPoint, size: CGSize) -> CGPoint {
        let x: CGFloat = center.x - size.width / 2
        if case .dynamic(let modalCenterPosition) = presentationType {
            if case .bottom(_) = modalCenterPosition{
                let y: CGFloat = center.y - size.height / 2 - (contentInset != 0 ? (contentInset + pannedHeight) : 0)
                return CGPoint(x: x, y: y)
            }
        }
        let y: CGFloat = center.y - size.height / 2
        return CGPoint(x: x, y: y)
    }
    
}

// MARK: - Gesture Handling

extension PresentrController {

    @objc func chromeViewTapped(gesture: UIGestureRecognizer) {
        guard dismissOnTap else {
            return
        }

        guard conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }

        if gesture.state == .ended {
            if shouldObserveKeyboard {
                removeObservers()
            }
            presentingViewController.dismiss(animated: dismissAnimated, completion: nil)
        }
    }

    @objc func presentedViewSwipe(gesture: UIPanGestureRecognizer) {
        guard dismissOnSwipe else {
            return
        }

        if gesture.state == .began {
            presentedViewFrame = presentedViewController.view.frame
            presentedViewCenter = presentedViewController.view.center

            let directionDown = gesture.translation(in: presentedViewController.view).y > 0
            if (shouldSwipeBottom && directionDown) || (shouldSwipeTop && !directionDown) {
                latestShouldDismiss = conformingPresentedController?.presentrShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true
            }
        } else if gesture.state == .changed {
            swipeGestureChanged(gesture: gesture)
        } else if gesture.state == .ended || gesture.state == .cancelled {
            swipeGestureEnded()
        }
    }

    // MARK: Helper's

    
    func swipeGestureChanged(gesture: UIPanGestureRecognizer) {
        
        let velocity = gesture.velocity(in: presentedViewController.view)
        let translation = gesture.translation(in: presentedViewController.view)
        if velocity.x / velocity.y < 5.0 {
            if presentedViewCenter.y + translation.y > presentedViewCenter.y {
                presentedViewController.view.center = CGPoint(x: presentedViewCenter.x, y: presentedViewCenter.y + translation.y)
            } else {
                pannedHeight = -translation.y / 10
                presentedView?.frame = CGRect(x: presentedViewFrame.origin.x, y: presentedViewFrame.origin.y - pannedHeight, width: presentedViewFrame.width, height: presentedViewFrame.height + pannedHeight)
            }
        }
        closeSpeed = velocity.y
        closePercent = translation.y / presentedViewFrame.height
    }

    func swipeGestureEnded() {
        if closeSpeed > 750.0 || closePercent > 0.33 {
            presentedViewController.dismiss(animated: dismissAnimated, completion: nil)
        } else {
            closeSpeed = 0.0
            closePercent = 0.0
            pannedHeight = 0.0
            
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: [],
                           animations: {
                            self.presentedView?.frame = self.presentedViewFrame
            }, completion: nil)
        }
    }
}

// MARK: - Keyboard Handling

extension PresentrController {

    @objc func keyboardWasShown(notification: Notification) {
        if let keyboardFrame = notification.keyboardEndFrame() {
            let presentedFrame = frameOfPresentedViewInContainerView
            let translatedFrame = keyboardTranslationType.getTranslationFrame(keyboardFrame: keyboardFrame, presentedFrame: presentedFrame)
            if translatedFrame != presentedFrame {
                UIView.animate(withDuration: notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView?.frame = translatedFrame
                })
            }
            keyboardIsShowing = true
        }
    }

    @objc func keyboardWillHide (notification: Notification) {
        if keyboardIsShowing {
            let presentedFrame = frameOfPresentedViewInContainerView
            if self.presentedView?.frame !=  presentedFrame {
                UIView.animate(withDuration: notification.keyboardAnimationDuration() ?? 0.5, animations: {
                    self.presentedView?.frame = presentedFrame
                })
            }
            keyboardIsShowing = false
        }
    }
}

extension PresentrController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        guard let view = pan.view as? UIScrollView else { return true }
        let point = pan.location(ofTouch: 0, in: view)
        let velocity = pan.velocity(in: view)
        let directionDown = pan.translation(in: view).y > 0
        guard (shouldSwipeBottom && directionDown) || (shouldSwipeTop && !directionDown) else {
            return false
        }
        if view.bounds.contains(point) && velocity.y > 0.0 && velocity.x / velocity.y < 5.0 && view.contentOffset == .zero {
            return true
        } else {
            return false
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer, pan.numberOfTouches > 0 else { return false }
        guard let _ = gestureRecognizer.view as? UIScrollView else {
            guard let otherView = otherGestureRecognizer.view as? UIScrollView else { return false }
            let point = pan.location(ofTouch: 0, in: otherView)
            let velocity = pan.velocity(in: otherView)
            let directionDown = pan.translation(in: otherView).y > 0
            guard (shouldSwipeBottom && directionDown) || (shouldSwipeTop && !directionDown) else {
                return false
            }
            if otherView.bounds.contains(point) && velocity.y > 0.0 && velocity.x / velocity.y < 5.0 && otherView.contentOffset == .zero {
                return true
            } else {
                return false
            }
        }
        return false
    }
}
