//
//  AlertAction.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 28/02/18.
//

public typealias AlertActionHandler = ((AlertAction) -> Void)

/// Describes each action that is going to be shown in the 'AlertViewController'
public class AlertAction {
    
    public let title: String
    public let style: AlertActionStyle
    public var isEnabled: Bool = true {
        didSet {
            button?.isEnabled = isEnabled
        }
    }
    public var autoDismiss: Bool = true
    
    let handler: AlertActionHandler?
    
    internal weak var button: UIButton?
    
    /**
     Initialized an 'AlertAction'
     
     - parameter title:   The title for the action, that will be used as the title for a button in the alert controller
     - parameter style:   The style for the action, that will be used to style a button in the alert controller.
     - parameter handler: The handler for the action, that will be called when the user clicks on a button in the alert controller.
     
     - returns: An inmutable AlertAction object
     */
    public init(title: String, style: AlertActionStyle, handler: AlertActionHandler?) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

/**
 Describes the style for an action, that will be used to style a button in the alert controller.
 
 - Default:     Green text label. Meant to draw attention to the action.
 - Cancel:      Gray text label. Meant to be neutral.
 - Destructive: Red text label. Meant to warn the user about the action.
 */
public enum AlertActionStyle {
    
    case `default`
    case cancel
    case destructive
}
