//
//  MainTableViewController.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 11/7/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr

enum ExampleSection {

    case uikit
    case actionsheet
    case alert
    case popup
    case topHalf
    case bottomHalf
    case advanced
    case other

    static var allSections: [ExampleSection] {
        return [.uikit, .actionsheet, .alert, .popup, .topHalf, .bottomHalf, .advanced, .other]
    }

    var items: [ExampleItem] {
        switch self {
        case .uikit:
            return [.alert, .actionSheet]
        case .actionsheet:
            return [.menuDefault, .actionSheetDefault]
        case .alert:
            return [.alertDefault, .alertCustom, .alertWithout]
        case .popup:
            return [.popupDefault, .popupCustom]
        case .topHalf:
            return [.topHalfDefault, .topHalfCustom]
        case .bottomHalf:
            return [.bottomHalfDefault, .bottomHalfCustom]
        case .other:
            return [.backgroundBlur, .customBackground, .keyboardTest, .fullScreen]
        case .advanced:
            return [.custom, .customAnimation, .modifiedAnimation, .coverVerticalWithSpring, .dynamicSize, .currentContext]
        }
    }

}

enum ExampleItem: String {

    case alert = "UIKit default alert"
    case actionSheet = "UIKit default actionSheet"
    
    case menuDefault = "Menù with default animation"
    case actionSheetDefault = "Actionsheet with default animation"
    
    case alertDefault = "Alert with default animation"
    case alertCustom = "Alert with custom animation"
    case alertWithout = "Alert without animation"

    case popupDefault = "Popup with default animation"
    case popupCustom = "Popup with custom animation"

    case topHalfDefault = "TopHalf with default animation"
    case topHalfCustom = "TopHalf with custom animation"

    case bottomHalfDefault = "BottomHalf with default animation"
    case bottomHalfCustom = "BottomHalf with custom animation"

    case fullScreen = "Full Screen"
    case customBackground = "Custom background"
    case keyboardTest = "Keyboard translation"
    case backgroundBlur = "Background blur"

    case custom = "Custom presentation"
    case customAnimation = "Custom user created animation"
    case modifiedAnimation = "Modified built in animation"
    case coverVerticalWithSpring = "Cover vertical with spring"
    case currentContext = "Using a custom context"
    case dynamicSize = "Using dynamic sizing (Auto Layout)"

    var action: Selector {
        switch self {
        case .alert:
            return #selector(MainTableViewController.uikitAlert)
        case .actionSheet:
            return #selector(MainTableViewController.uikitActionSheet)
            
        case .menuDefault:
            return #selector(MainTableViewController.menuDefault)
        case .actionSheetDefault:
            return #selector(MainTableViewController.actionSheetDefault)
        case .alertDefault:
            return #selector(MainTableViewController.alertDefault)
        case .alertCustom:
            return #selector(MainTableViewController.alertCustom)
        case .alertWithout:
            return #selector(MainTableViewController.alertDefaultWithoutAnimation)

        case .popupDefault:
            return #selector(MainTableViewController.popupDefault)
        case .popupCustom:
            return #selector(MainTableViewController.popupCustom)

        case .topHalfDefault:
            return #selector(MainTableViewController.topHalfDefault)
        case .topHalfCustom:
            return #selector(MainTableViewController.topHalfCustom)

        case .bottomHalfDefault:
            return #selector(MainTableViewController.bottomHalfDefault)
        case .bottomHalfCustom:
            return #selector(MainTableViewController.bottomHalfCustom)

        case .fullScreen:
            return #selector(MainTableViewController.fullScreenPresentation)
        case .backgroundBlur:
            return #selector(MainTableViewController.backgroundBlurTest)
        case .keyboardTest:
            return #selector(MainTableViewController.keyboardTranslationTest)
        case .customBackground:
            return #selector(MainTableViewController.customBackgroundPresentation)


        case .custom:
            return #selector(MainTableViewController.customPresentation)
        case .customAnimation:
            return #selector(MainTableViewController.customAnimation)
        case .modifiedAnimation:
            return #selector(MainTableViewController.modifiedAnimation)
        case .coverVerticalWithSpring:
            return #selector(MainTableViewController.coverVerticalWithSpring)
        case .currentContext:
            return #selector(MainTableViewController.currentContext)
        case .dynamicSize:
            return #selector(MainTableViewController.dynamicSize)
        }
    }

}

class MainTableViewController: UITableViewController {

    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()

    let menuPresesenter: Presentr = {
        let center = ModalCenterPosition.bottom(percentage: 0.8, fixedWidth: false)
        let presentationType = PresentationType.dynamic(center: center)
        let presenter = Presentr(presentationType: presentationType)
        
        presenter.appearance.contentInset = 0
        presenter.appearance.roundCorners = false
        presenter.dismissOnSwipe = true
        presenter.appearance.actionSheet.item.textAlignment = .left
        presenter.appearance.actionSheet.header.textAlignment = .left
        presenter.appearance.actionSheet.header.font = UIFont.preferredFont(forTextStyle: .body)
        presenter.appearance.actionSheet.header.detailTextFont = UIFont.preferredFont(forTextStyle: .caption2)
        presenter.appearance.actionSheet.item.font = UIFont.preferredFont(forTextStyle: .caption2)
        return presenter
    }()
    
    let actionSheetPresenter: Presentr = {
        let center = ModalCenterPosition.bottom(percentage: 0.8, fixedWidth: true)
        let presentationType = PresentationType.dynamic(center: center)
        
        let presenter = Presentr(presentationType: presentationType)
        presenter.dismissOnSwipe = false
        presenter.appearance.actionSheet.item.textAlignment = .center
        presenter.appearance.actionSheet.header.textAlignment = .center
        presenter.appearance.actionSheet.title.font = UIFont.preferredFont(forTextStyle: .body)
        presenter.appearance.actionSheet.item.font = UIFont.preferredFont(forTextStyle: .caption2)
        presenter.appearance.actionSheet.title.messageTextFont = UIFont.preferredFont(forTextStyle: .caption2)
        return presenter
    }()
    
    let dynamicSizePresenter: Presentr = {
        let presentationType = PresentationType.dynamic(center: .center)
        let presenter = Presentr(presentationType: presentationType)
        return presenter
    }()

    let customPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)

        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .crossDissolve
        customPresenter.appearance.roundCorners = false
        customPresenter.appearance.backgroundColor = .green
        customPresenter.appearance.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        return customPresenter
    }()

    let customBackgroundPresenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.fluid(percentage: 0.20)
        let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        
        customPresenter.appearance.backgroundColor = .yellow
        customPresenter.appearance.backgroundOpacity = 0.5
        
        let view = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        view.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: UIScreen.main.bounds.height / 2 - 50, width: 100, height: 100)
        view.contentMode = .scaleAspectFit
        customPresenter.appearance.customBackgroundView = view

        return customPresenter
    }()

    lazy var alertController: AlertViewController = {
        let alertController = AlertViewController(title: "Are you sure?", body: "This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone!")
        let appearance = alertController.appearance
        appearance.title.font = UIFont.preferredFont(forTextStyle: .body)
        appearance.body.font = UIFont.preferredFont(forTextStyle: .caption2)
        appearance.title.textColor = .black
        appearance.body.textColor = .darkGray
        appearance.backgroundColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        appearance.button.font = UIFont.preferredFont(forTextStyle: .caption2)
        appearance.button.textColor = .darkGray
        appearance.defaultButton.font = UIFont.preferredFont(forTextStyle: .caption2)
        appearance.defaultButton.textColor = .darkGray
        let cancelAction = AlertAction(title: "NO, SORRY!", style: .default) { alert in
            print("CANCEL!!")
        }
        let okAction = AlertAction(title: "DO IT!", style: .destructive) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        return alertController
    }()

    lazy var popupViewController: PopupViewController = {
        let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopupViewController")
        return popupViewController as! PopupViewController
    }()

    var logoView: UIImageView {
        let logoView = UIImageView(image: #imageLiteral(resourceName: "Logo"))
        logoView.contentMode = .scaleAspectFit
        logoView.frame.size.width = 30
        logoView.frame.size.height = 30
        return logoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = logoView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return ExampleSection.allSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = ExampleSection.allSections[section]
        return section.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath) as! ExampleTableViewCell

        let item = itemFor(indexPath: indexPath)
        cell.exampleLabel.text = item.rawValue

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleItem(itemFor(indexPath: indexPath))
//        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: ExampleItem handling

    func itemFor(indexPath: IndexPath) -> ExampleItem {
        let section = ExampleSection.allSections[indexPath.section]
        return section.items[indexPath.row]
    }

    func handleItem(_ item: ExampleItem) {
        performSelector(onMainThread: item.action, with: nil, waitUntilDone: false)
    }

}

// MARK: - Presentation Examples

extension MainTableViewController {

    @objc func uikitAlert() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "NO, SORRY!", style: .default) { alert in
            print("CANCEL!!")
        }
        let okAction = UIAlertAction(title: "DO IT!", style: .cancel) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: CGSize(width: 300, height: 200))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func uikitActionSheet() {
        let alertController = UIAlertController(title: "Are you sure?", message: "This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone! This action can't be undone!", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "NO, SORRY!", style: .default) { alert in
            print("CANCEL!!")
        }
        let okAction = UIAlertAction(title: "DO IT!", style: .destructive) { alert in
            print("OK!!")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(origin: self.view.center, size: CGSize(width: 300, height: 200))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Alert

    @objc func menuDefault() {
        let header = ActionSheetHeader(title: "pippo.pdf", subtitle: "sottotitolo", image: nil, accessoryImage: nil)
        let actionSheetController = ActionSheetController(header: header)
        let appearance = actionSheetController.appearance
        appearance.item.shouldShowSeparator = false
        appearance.header.font = UIFont.preferredFont(forTextStyle: .body)
        appearance.item.font = UIFont.preferredFont(forTextStyle: .body)
        appearance.header.detailTextFont = UIFont.preferredFont(forTextStyle: .caption2)
        actionSheetController.addAction(ActionSheetAction(title: "action 1", image: nil, handler: { (action) in
            print("action 1")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 2", image: nil, handler: { (action) in
            print("action 2")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 3", image: nil, handler: { (action) in
            print("action 3")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 4", image: nil, handler: { (action) in
            print("action 4")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 5", image: nil, handler: { (action) in
            print("action 5")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 6", image: nil, handler: { (action) in
            print("action 6")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 7", image: nil, handler: { (action) in
            print("action 7")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 8", image: nil, handler: { (action) in
            print("action 8")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 9", image: nil, handler: { (action) in
            print("action 9")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 10", image: nil, handler: { (action) in
            print("action 10")
        }))
        customPresent(actionSheetController, presentr: menuPresesenter, from: tableView.cellForRow(at: tableView.indexPathForSelectedRow!), animated: true)
    }
    
    @objc func actionSheetDefault() {
        let actionSheetController = ActionSheetController(title: "Are you sure?", message: "This action can't be undone!", cancelAction: ActionSheetAction(title: "Cancel", image: nil, handler: nil))
//        let appearance = actionSheetController.appearance
//        appearance.item.shouldShowSeparator = true
//        appearance.item.separatorInsets = .zero
//        appearance.item.textAlignment = .center
//        appearance.title.textAlignment = .center
//        appearance.title.font = UIFont.preferredFont(forTextStyle: .body)
//        appearance.item.font = UIFont.preferredFont(forTextStyle: .caption2)
//        appearance.title.messageTextFont = UIFont.preferredFont(forTextStyle: .caption2)
        actionSheetController.addAction(ActionSheetAction(title: "action 1", image: nil, handler: { (action) in
            print("action 1")
        }))
        actionSheetController.addAction(ActionSheetAction(title: "action 2", image: nil, handler: { (action) in
            print("action 2")
        }))
        customPresent(actionSheetController, presentr: actionSheetPresentr, from: tableView.cellForRow(at: tableView.indexPathForSelectedRow!), animated: true)
    }
    
    @objc func alertDefault() {
        presenter.presentationType = .dynamic(center: .center)
        presenter.transitionType = .crossDissolve
        presenter.dismissTransitionType = .crossDissolve
        presenter.dismissOnSwipe = false
        presenter.dismissOnTap = false
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func alertCustom() {
        presenter.presentationType = .alert
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.dismissTransitionType = .coverHorizontalFromRight
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func alertDefaultWithoutAnimation() {
        presenter.presentationType = .alert
        presenter.dismissAnimated = false
        customPresent(alertController, presentr: presenter, animated: false)
    }

    // MARK: Popup

    @objc func popupDefault() {
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func popupCustom() {
        presenter.presentationType = .popup
        presenter.transitionType = .coverHorizontalFromRight
        presenter.dismissTransitionType = .coverVerticalFromTop
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    // MARK: Top Half

    @objc func topHalfDefault() {
        presenter.presentationType = .topHalf
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func topHalfCustom() {
        presenter.presentationType = .topHalf
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.dismissTransitionType = .coverVerticalFromTop
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    // MARK: Bottom Half

    @objc func bottomHalfDefault() {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func bottomHalfCustom() {
        presenter.presentationType = .bottomHalf
        presenter.transitionType = .coverHorizontalFromLeft
        presenter.transitionType = .crossDissolve
        presenter.dismissAnimated = true
        customPresent(alertController, presentr: presenter, animated: true)
    }

    // MARK: Other

    @objc func fullScreenPresentation() {
        presenter.presentationType = .fullScreen
        presenter.transitionType = .coverVertical
        presenter.dismissTransitionType = .crossDissolve
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func customBackgroundPresentation() {
        customPresent(alertController, presentr: customBackgroundPresenter, animated: true)
    }

    @objc func keyboardTranslationTest() {
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        presenter.dismissOnSwipe = true
        customPresent(popupViewController, presentr: presenter, animated: true)
    }

    @objc func backgroundBlurTest() {
        presenter.presentationType = .alert
        presenter.appearance.blurBackground = true
        alertDefault()
        presenter.appearance.blurBackground = false
    }

    // MARK: Advanced

    @objc func customPresentation() {
        customPresent(alertController, presentr: customPresenter, animated: true)
    }

    @objc func customAnimation() {
        presenter.presentationType = .alert
        presenter.transitionType = TransitionType.custom(CustomAnimation())
        presenter.dismissTransitionType = TransitionType.custom(CustomAnimation())
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func modifiedAnimation() {
        presenter.presentationType = .alert
        let modifiedAnimation = CrossDissolveAnimation(options: .normal(duration: 1.0))
        presenter.transitionType = TransitionType.custom(modifiedAnimation)
        presenter.dismissTransitionType = TransitionType.custom(modifiedAnimation)
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func coverVerticalWithSpring() {
        presenter.presentationType = .alert
        let animation = CoverVerticalAnimation(options: .spring(duration: 2.0,
                                                                delay: 0,
                                                                damping: 0.5,
                                                                velocity: 0))
        let coverVerticalWithSpring = TransitionType.custom(animation)
        presenter.transitionType = coverVerticalWithSpring
        presenter.dismissTransitionType = coverVerticalWithSpring
        customPresent(alertController, presentr: presenter, animated: true)
    }

    @objc func dynamicSize() {
        let dynamicVC = storyboard!.instantiateViewController(withIdentifier: "DynamicViewController")
        customPresent(dynamicVC, presentr: dynamicSizePresenter, animated: true)
    }

    @objc func currentContext() {
        let splitVC = storyboard!.instantiateViewController(withIdentifier: "SplitViewController")
        navigationController?.pushViewController(splitVC, animated: true)
    }
}
