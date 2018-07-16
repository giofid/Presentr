//
//  AlertViewController.swift
//  OneUP
//
//  Created by Daniel Lozano on 5/10/16.
//  Copyright © 2016 Icalia Labs. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

public enum AlertViewStyle {
    case `default`
    case activityIndicator
}

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
    
    /// TextField
    public var textFields: [UITextField] = []

    fileprivate var actions = [AlertAction]()
    
    private let isBodyEmpty: Bool
    
    private var style: AlertViewStyle

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var customViewsStackView: UIStackView!
    @IBOutlet weak var actionsStackView: UIStackView!
    @IBOutlet weak var firstButtonHeightConstraint: NSLayoutConstraint!
    
    open lazy var appearance: AlertAppearance = {
        return AlertAppearance(copy: PresentrAppearance.standard.alert)
    }()

    public init(title: String?, body: String?, style: AlertViewStyle = .default) {
        self.titleText = title
        self.bodyText = body
        self.isBodyEmpty = body?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
        self.style = style
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

        
        setupCustomViewsStackView()
        setupLabels()
        setupButtons()
        
        if customViewsStackView.arrangedSubviews.isEmpty {
            customViewsStackView.removeFromSuperview()
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !textFields.isEmpty {
            textFields[0].becomeFirstResponder()
        }
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

    public func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) {
        assert(style == .default, "Text fields can only be added to an alert view controller of style .default")
        let textField = PaddingUITextField()
        textField.leftInset = 12
        textField.rightInset = 12
        if bodyText?.isEmpty ?? true {
            bodyText = " "
        }
        configurationHandler?(textField)
        textFields.append(textField)
    }
    
    public func showError(message: String) {
        assert(!textFields.isEmpty && isBodyEmpty, "An error can only be showed if there's at least a text field and body text is empty.")
        bodyLabel.text = message
        bodyLabel.textAlignment = .left
        bodyLabel.textColor = .red
    }
    
    // MARK: Setup

    fileprivate func setupCustomViewsStackView() {
        
        func setupActivityIndicatorView() {
            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
            activityIndicator.type = appearance.activityIndicator.type
            activityIndicator.color = appearance.activityIndicator.color
            customViewsStackView.addArrangedSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
        
        func setupTextField() {
            for i in 0 ..< textFields.count {
                let textField = textFields[i]
                textField.font = appearance.body.font
                textField.textColor = appearance.body.textColor
                textField.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1)
                textField.borderWidth = 0.5
                textField.backgroundColor = .white
                textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
                textField.autocorrectionType = .no
                if textField === textFields.last {
                    textField.returnKeyType = .done
                    textField.addTarget(textField, action: #selector(UIResponder.resignFirstResponder), for: .editingDidEndOnExit)
                } else {
                    textField.returnKeyType = .next
                    textField.addTarget(textFields[i+1], action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
                }
                customViewsStackView.addArrangedSubview(textField)
            }
        }
        
        if style == .activityIndicator {
            setupActivityIndicatorView()
        }
        setupTextField()
        if customViewsStackView.arrangedSubviews.isEmpty {
            customViewsStackView.removeFromSuperview()
        }
    }
    
    fileprivate func setupLabels() {
        if let titleText = titleText {
            titleLabel.font = appearance.title.font
            titleLabel.textColor = appearance.title.textColor
            titleLabel.text = titleText
        } else {
            titleLabel.removeFromSuperview()
        }
        if let bodyText = bodyText {
            bodyLabel.font = appearance.body.font
            bodyLabel.textColor = appearance.body.textColor
            bodyLabel.text = bodyText
        } else {
            bodyLabel.removeFromSuperview()
        }
        
    }

    fileprivate func setupButtons() {
        guard let firstAction = actions.first else { return }
        actionsStackView.axis = appearance.actionsAxis
        if actionsStackView.axis == .vertical {
            actionsStackView.spacing = 10
            actionsStackView.isLayoutMarginsRelativeArrangement = true
            actionsStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            firstButtonHeightConstraint.constant = 45
        }
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
        toButton.isEnabled = action.isEnabled
        toButton.titleLabel?.numberOfLines = 0
        toButton.titleLabel?.preferredMaxLayoutWidth = 230
        toButton.titleLabel?.textAlignment = .center
        let style = action.style
        let alphaComponent: CGFloat = 0.25
        switch style {
        case .default:
            toButton.setTitleColor(appearance.defaultButton.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.defaultButton.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.defaultButton.font
            toButton.setBackgroundColor(appearance.defaultButton.backgroundColor, forState: .normal)
            toButton.setBackgroundColor(appearance.defaultButton.selectedBackgroundColor, forState: .highlighted)
            toButton.layer.cornerRadius = appearance.defaultButton.cornerRadius ?? toButton.layer.cornerRadius
            toButton.layer.borderColor = appearance.defaultButton.borderColor?.cgColor
            toButton.layer.borderWidth = appearance.defaultButton.borderWidth ?? toButton.layer.borderWidth
            if let minimumScaleFactor = appearance.defaultButton.minimumScaleFactor {
                toButton.titleLabel?.minimumScaleFactor = minimumScaleFactor
            }
        case .cancel:
            toButton.setTitleColor(appearance.button.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.button.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.button.font
            toButton.setBackgroundColor(appearance.button.backgroundColor, forState: .normal)
            toButton.setBackgroundColor(appearance.button.selectedBackgroundColor, forState: .highlighted)
            toButton.layer.cornerRadius = appearance.button.cornerRadius ?? toButton.layer.cornerRadius
            toButton.layer.borderColor = appearance.button.borderColor?.cgColor
            toButton.layer.borderWidth = appearance.button.borderWidth ?? toButton.layer.borderWidth
            if let minimumScaleFactor = appearance.button.minimumScaleFactor {
                toButton.titleLabel?.minimumScaleFactor = minimumScaleFactor
            }
        case .destructive:
            toButton.setTitleColor(appearance.destructiveButton.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.destructiveButton.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.destructiveButton.font
            toButton.setBackgroundColor(appearance.destructiveButton.backgroundColor, forState: .normal)
            toButton.setBackgroundColor(appearance.destructiveButton.selectedBackgroundColor, forState: .highlighted)
            toButton.layer.cornerRadius = appearance.destructiveButton.cornerRadius ?? toButton.layer.cornerRadius
            toButton.layer.borderColor = appearance.destructiveButton.borderColor?.cgColor
            toButton.layer.borderWidth = appearance.destructiveButton.borderWidth ?? toButton.layer.borderWidth
            if let minimumScaleFactor = appearance.destructiveButton.minimumScaleFactor {
                toButton.titleLabel?.minimumScaleFactor = minimumScaleFactor
            }
        }
        action.button = toButton
    }

    // MARK: IBAction's

    @IBAction func didSelectFirstAction(_ sender: AnyObject) {
        guard let firstAction = actions.first else { return }
        dismiss(action: firstAction)
        if let handler = firstAction.handler {
            handler(firstAction)
        }
    }

    @IBAction func didSelectSecondAction(_ sender: AnyObject) {
        guard let secondAction = actions.last, actions.count == 2 else { return }
        dismiss(action: secondAction)
        if let handler = secondAction.handler {
            handler(secondAction)
        }
    }
    
    // MARK: Helper's

    private func dismiss(action: AlertAction) {
        guard autoDismiss && action.autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }
}
