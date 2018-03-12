//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit

/// UIViewController subclass that displays the alert
public class AlertViewController: UIViewController {

    /// Text that will be used as the title for the alert
    public var titleText: String?

    /// Text that will be used as the body for the alert
    public var bodyText: String?

    /// If set to false, alert wont auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true

    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true

    fileprivate var actions = [AlertAction]()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!

    open lazy var appearance: AlertAppearance = {
        return AlertAppearance(copy: PresentrAppearance.standard.alert)
    }()

    public init(title: String, body: String) {
        self.titleText = title
        self.bodyText = body
        super.init(nibName: "AlertViewController", bundle: Bundle(for: AlertViewController.self))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var shouldAutorotate: Bool {
        return presentingViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return presentingViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        if actions.isEmpty {
            let okAction = AlertAction(title: "OK", style: .default, handler: nil)
            addAction(okAction)
        }
        
        self.view.backgroundColor = appearance.backgroundColor

        setupLabels()
        setupButtons()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: AlertAction's

    /**
     Adds an 'AlertAction' to the alert controller. There can be maximum 2 actions. Any more will be ignored. The order is important.

     - parameter action: The 'AlertAction' to be added
     */
    public func addAction(_ action: AlertAction) {
        guard actions.count < 2 else { return }
        actions += [action]
    }

    // MARK: Setup

    fileprivate func setupLabels() {
        titleLabel.font = appearance.title.font
        titleLabel.textColor = appearance.title.textColor
        titleLabel.text = titleText
        bodyLabel.font = appearance.body.font
        bodyLabel.textColor = appearance.body.textColor
        bodyLabel.text = bodyText
    }

    fileprivate func setupButtons() {
        guard let firstAction = actions.first else { return }
        apply(firstAction, toButton: firstButton)
        if actions.count == 2 {
            let secondAction = actions.last!
            apply(secondAction, toButton: secondButton)
        } else {
            secondButton.removeFromSuperview()
        }
    }

    fileprivate func apply(_ action: AlertAction, toButton: UIButton) {
        let title = action.title.uppercased()
        toButton.setTitle(title, for: UIControlState())
        let style = action.style
        switch style {
        case .default:
            toButton.setTitleColor(appearance.defaultButton.textColor, for: UIControlState())
            toButton.titleLabel?.font = appearance.defaultButton.font
            toButton.backgroundColor = appearance.defaultButton.backgroundColor
        case .cancel:
            toButton.setTitleColor(appearance.button.textColor, for: UIControlState())
            toButton.titleLabel?.font = appearance.button.font
            toButton.backgroundColor = appearance.button.backgroundColor
        case .destructive:
            toButton.setTitleColor(appearance.button.textColor, for: UIControlState())
            toButton.titleLabel?.font = appearance.button.font
            toButton.backgroundColor = appearance.button.backgroundColor
        }
    }

    // MARK: IBAction's

    @IBAction func didSelectFirstAction(_ sender: AnyObject) {
        guard let firstAction = actions.first else { return }
        dismiss()
        if let handler = firstAction.handler {
            handler(firstAction)
        }
    }

    @IBAction func didSelectSecondAction(_ sender: AnyObject) {
        guard let secondAction = actions.last, actions.count == 2 else { return }
        dismiss()
        if let handler = secondAction.handler {
            handler(secondAction)
        }
    }

    // MARK: Helper's

    func dismiss() {
        guard autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }
}
