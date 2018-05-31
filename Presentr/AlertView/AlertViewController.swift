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
    
    /// TextField
    public var textFields: [UITextField] = []

    fileprivate var actions = [AlertAction]()
    
    private let isBodyEmpty: Bool

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var firstButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldsStackView: UIStackView!
    
    open lazy var appearance: AlertAppearance = {
        return AlertAppearance(copy: PresentrAppearance.standard.alert)
    }()

    public init(title: String, body: String) {
        self.titleText = title
        self.bodyText = body
        self.isBodyEmpty = body.trimmingCharacters(in: .whitespaces).isEmpty
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

        setupTextField()
        setupLabels()
        setupButtons()
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
        let textField = PaddingUITextField()
        textField.leftInset = 12
        textField.rightInset = 12
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

    fileprivate func setupTextField() {
        for textField in textFields {
            textField.font = appearance.body.font
            textField.textColor = appearance.body.textColor
            textField.borderColor = UIColor(red: 218.0/255.0, green: 218.0/255.0, blue: 218.0/255.0, alpha: 1)
            textField.borderWidth = 0.5
            textField.backgroundColor = .white
            textField.heightAnchor.constraint(equalToConstant: 36).isActive = true
            textField.delegate = self
            textField.returnKeyType = .done
            textField.autocorrectionType = .no
            textFieldsStackView.addArrangedSubview(textField)
        }
    }
    
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
        toButton.isEnabled = action.isEnabled
        let style = action.style
        let alphaComponent: CGFloat = 0.25
        switch style {
        case .default:
            toButton.setTitleColor(appearance.defaultButton.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.defaultButton.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.defaultButton.font
            toButton.backgroundColor = appearance.defaultButton.backgroundColor
        case .cancel:
            toButton.setTitleColor(appearance.button.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.defaultButton.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.button.font
            toButton.backgroundColor = appearance.button.backgroundColor
        case .destructive:
            toButton.setTitleColor(appearance.button.textColor, for: UIControlState())
            toButton.setTitleColor(appearance.defaultButton.textColor?.withAlphaComponent(alphaComponent), for: .disabled)
            toButton.titleLabel?.font = appearance.button.font
            toButton.backgroundColor = appearance.button.backgroundColor
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

extension AlertViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
