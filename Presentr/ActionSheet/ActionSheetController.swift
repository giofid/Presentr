//
//  ActionSheetController.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 15/02/18.
//

import UIKit

private enum ActionSheetStyle {
    case menu
    case actionsheet
}

public class ActionSheetController: UIViewController {

    @IBOutlet var headerTableView: UITableView! {
        didSet {
            headerTableView.estimatedRowHeight = appearance.header.height
            switch style {
            case .menu:
                headerTableView.dataSource = headerHandler
                headerTableView.delegate = headerHandler
            case .actionsheet:
                headerTableView.dataSource = titleHandler
                headerTableView.delegate = titleHandler
            }
        }
    }
    
    @IBOutlet weak var actionsTableView: UITableView! {
        didSet {
            actionsTableView.estimatedRowHeight = appearance.item.height
            actionsTableView.separatorStyle = appearance.item.shouldShowSeparator ? .singleLine : .none
            actionsTableView.tableFooterView = UIView(frame: .zero)
            actionsTableView.separatorInset = appearance.item.separatorInsets
            actionsTableView.dataSource = actionsHandler
            actionsTableView.delegate = actionsHandler
        }
    }
    
    @IBOutlet var cancelTableView: AutoSizingTableView! {
        didSet {
            cancelTableView.estimatedRowHeight = appearance.item.height
            if appearance.roundCorners == true {
                cancelTableView.layer.cornerRadius = appearance.cornerRadius
                cancelTableView.layer.masksToBounds = true
            } else {
                cancelTableView.layer.cornerRadius = 0
            }
            cancelTableView.dataSource = cancelHandler
            cancelTableView.delegate = cancelHandler
        }
    }
    
    @IBOutlet weak var headerActionView: UIView! {
        didSet {
            if appearance.roundCorners == true {
                headerActionView.layer.cornerRadius = appearance.cornerRadius
                headerActionView.layer.masksToBounds = true
            } else {
                headerActionView.layer.cornerRadius = 0
            }
        }
    }
    
    @IBOutlet weak var headerActionsView: UIStackView!
    @IBOutlet var separatorView: SeparatorView!
    
    @IBOutlet weak var containerView: UIStackView! {
        didSet {
            containerView.spacing = appearance.contentInset
        }
    }
    
    fileprivate var hasToShowHeader: Bool?
    
    open lazy var appearance: ActionSheetAppearance = {
        return ActionSheetAppearance(copy: PresentrAppearance.standard.actionSheet)
    }()
    
    /// If set to false, action sheet won't auto-dismiss the controller when an action is clicked. Dismissal will be up to the action's handler. Default is true.
    public var autoDismiss: Bool = true
    
    /// If autoDismiss is set to true, then set this property if you want the dismissal to be animated. Default is true.
    public var dismissAnimated: Bool = true
    
    fileprivate var actions = [ActionSheetAction]()
    
     fileprivate let actionSheetTitle: ActionSheetTitle?
    
    fileprivate let header: ActionSheetHeader?
    
    fileprivate let cancel: ActionSheetAction?
    
    private let style: ActionSheetStyle
    
    private lazy var actionsHandler: ActionSheetItemHandler = {
        let handler = ActionSheetItemHandler(collectionType: .actions(actions: actions))
        handler.delegate = self
        return handler
    }()
    
    private lazy var cancelHandler: ActionSheetItemHandler? = {
        guard let cancel = cancel else { return nil }
        let handler = ActionSheetItemHandler(collectionType: .actions(actions: [cancel]))
        handler.delegate = self
        return handler
    }()
    
    public lazy var headerHandler: ActionSheetItemHandler? = {
        guard let header = header else { return nil }
        let handler = ActionSheetItemHandler(collectionType: .header(header: header))
        handler.delegate = self
        return handler
    }()
    
    public lazy var titleHandler: ActionSheetItemHandler? = {
        guard let title = actionSheetTitle else { return nil }
        let handler = ActionSheetItemHandler(collectionType: .title(title: title))
        handler.delegate = self
        return handler
    }()
    
    public init(header: ActionSheetHeader? = nil) {
        self.header = header
        self.actionSheetTitle = nil
        self.cancel = nil
        style = .menu
        super.init(nibName: "ActionSheetController", bundle: Bundle(for: ActionSheetController.self))
    }
    
    public init(title: String?, message: String?, cancelAction: ActionSheetAction) {
        style = .actionsheet
        cancel = cancelAction
        header = nil
        if title != nil || message != nil {
            actionSheetTitle = ActionSheetTitle(title: title, message: message)
        } else {
            actionSheetTitle = nil
        }
        super.init(nibName: "ActionSheetController", bundle: Bundle(for: ActionSheetController.self))
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
        self.actionsTableView.alwaysBounceVertical = false
        self.headerTableView.alwaysBounceVertical = false
        self.cancelTableView.alwaysBounceVertical = false
        if style == .menu {
            if containerView.arrangedSubviews.count == 2 {
                containerView.removeArrangedSubview(cancelTableView)
                cancelTableView.removeFromSuperview()
            }
        }
        actionSheetTitle?.applyAppearance(appearance)
        actions.forEach { $0.applyAppearance(appearance) }
        header?.applyAppearance(appearance)
        cancel?.applyAppearance(appearance)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        preferredContentSize.height = headerActionView.intrinsicContentSize.height
    }
    
    public override var preferredContentSize: CGSize {
        get { return CGSize(width: super.preferredContentSize.width, height: headerActionView.intrinsicContentSize.height) }
        set { super.preferredContentSize = newValue }
    }
    
    /**
     Adds an 'ActionSheetAction' to the actionsheet controller. The order is important.
     
     - parameter action: The 'ActionSheetAction' to be added
     */
    public func addAction(_ action: ActionSheetAction) {
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
        view.backgroundColor = .white
        if isViewLoaded {
            switch style {
            case .menu:
                if headerActionsView.arrangedSubviews.count == 3 {
                    headerActionsView.removeArrangedSubview(headerTableView)
                    headerTableView.removeFromSuperview()
                    headerActionsView.removeArrangedSubview(separatorView)
                    separatorView.removeFromSuperview()
                }
            case .actionsheet:
                if containerView.arrangedSubviews.count == 2 {
                    containerView.removeArrangedSubview(cancelTableView)
                    cancelTableView.removeFromSuperview()
                }
            }
        }
    }
    
    func adjustForStandardPresentation() {
        hasToShowHeader = true
        view.backgroundColor = appearance.contentInset != 0 ? .clear : .white
        if isViewLoaded {
            switch style {
            case .menu:
                if actionSheetTitle == nil && header == nil && headerActionsView.arrangedSubviews.count == 3 {
                    headerActionsView.removeArrangedSubview(headerTableView)
                    headerTableView.removeFromSuperview()
                    headerActionsView.removeArrangedSubview(separatorView)
                    separatorView.removeFromSuperview()
                } else if (actionSheetTitle != nil || header != nil) && headerActionsView.arrangedSubviews.count == 1 {
                    headerActionsView.insertArrangedSubview(headerTableView, at: 0)
                    headerActionsView.insertArrangedSubview(separatorView, at: 1)
                }
            case .actionsheet:
                if actionSheetTitle == nil && header == nil && headerActionsView.arrangedSubviews.count == 3 {
                    headerActionsView.removeArrangedSubview(headerTableView)
                    headerTableView.removeFromSuperview()
                    headerActionsView.removeArrangedSubview(separatorView)
                    separatorView.removeFromSuperview()
                }
                if containerView.arrangedSubviews.count == 1 {
                    containerView.addArrangedSubview(cancelTableView)
                }
            }
        }
    }
}
