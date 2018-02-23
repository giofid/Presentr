//
//  ActionSheetController.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 15/02/18.
//

import UIKit

public class ActionSheetController: UIViewController {

    @IBOutlet var headerTableView: UITableView! {
        didSet {
            headerTableView.estimatedRowHeight = appearance.header.height
            headerTableView.dataSource = headerHandler
            headerTableView.delegate = headerHandler
        }
    }
    
    @IBOutlet weak var actionsTableView: UITableView! {
        didSet {
            actionsTableView.estimatedRowHeight = appearance.item.height
            actionsTableView.dataSource = actionsHandler
            actionsTableView.delegate = actionsHandler
        }
    }
    
    @IBOutlet weak var containerView: UIStackView!
    
    fileprivate var hasToShowHeader: Bool?
    
    open lazy var appearance: PresentrAppearance = {
        return PresentrAppearance(copy: .standard)
    }()
    
    /// If set to false, action sheet won't auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true
    
    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true
    
    fileprivate var actions = [ActionSheetAction]()
    
    fileprivate let header: ActionSheetHeader?
    
    private lazy var actionsHandler: ActionSheetItemHandler = {
        let handler = ActionSheetItemHandler(collectionType: .actions(actions: actions))
        handler.delegate = self
        return handler
    }()
    
    public lazy var headerHandler: ActionSheetItemHandler? = {
        guard let header = header else { return nil }
        let handler = ActionSheetItemHandler(collectionType: .header(header: header))
        handler.delegate = self
        return handler
    }()
    
    public init(header: ActionSheetHeader? = nil) {
        self.header = header
        super.init(nibName: "ActionSheetController", bundle: Bundle(for: ActionSheetController.self))
        header?.applyAppearance(appearance)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.header = nil
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.actionsTableView.alwaysBounceVertical = false
        self.headerTableView.alwaysBounceVertical = false
        if hasToShowHeader == false {
            if containerView.arrangedSubviews.count == 2 {
                containerView.removeArrangedSubview(headerTableView)
            }
        }
    }
    
    public override var preferredContentSize: CGSize {
        get { return CGSize(width: super.preferredContentSize.width, height: containerView.intrinsicContentSize.height) }
        set { super.preferredContentSize = newValue }
    }
    
    /**
     Adds an 'ActionSheetAction' to the actionsheet controller. The order is important.
     
     - parameter action: The 'ActionSheetAction' to be added
     */
    public func addAction(_ action: ActionSheetAction) {
        action.applyAppearance(appearance)
        actions.append(action)
    }
    
    // MARK: Helper's
    
    func dismiss() {
        guard autoDismiss else { return }
        self.dismiss(animated: dismissAnimated, completion: nil)
    }
}

extension ActionSheetController: ActionSheetItemHandlerDelegate {
    func handler(_ handler: ActionSheetItemHandler, didSelectItem: ActionSheetItem) {
        dismiss()
    }
}

extension ActionSheetController: AdaptivePresentedControllerDelegate {
    
    func adjustForPopoverPresentation() {
        hasToShowHeader = false
        if isViewLoaded {
            if containerView.arrangedSubviews.count == 2 {
                containerView.removeArrangedSubview(headerTableView)
            }
        }
    }
    
    func adjustForStandardPresentation() {
        hasToShowHeader = true
        if isViewLoaded {
            if containerView.arrangedSubviews.count == 1 {
                containerView.insertArrangedSubview(headerTableView, at: 0)
            }
        }
    }
}
