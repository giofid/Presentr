//
//  ActionSheetTitle.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 01/03/18.
//

import UIKit

/// Describes each action that is going to be shown in the 'ActionSheetController'
public class ActionSheetTitle: ActionSheetItem {
    
    public let message: String?
    
    /**
     Initialized an 'ActionSheetAction'
     
     - parameter title:   The title for the action, that will be used as the title for a row in the action sheet controller.
     - parameter image:   The image for the action, that will be used as an icon for the row in the action sheet controller.
     - parameter handler: The handler for the action, that will be called when the user clicks on a row in the action sheet controller.
     
     - returns: An inmutable ActionSheetAction object
     */
    public init(title: String?, message: String?) {
        self.message = message
        super.init(title: title, image: nil)
        super.setup(delegate: self)
    }
}

extension ActionSheetTitle: ActionSheetItemProtocol {
    
    var titleAppearance: ActionSheetTitleAppearance? {
        return appearance as? ActionSheetTitleAppearance
    }
    
    func applyAppearance(_ appearance: ActionSheetAppearance) {
        self.appearance.applyAppearance(appearance.title)
    }
    
    func applyAppearance(to cell: MinHeightTableViewCell) {
        guard let cell = cell as? ActionSheetTitleCell else { return }
        cell.isUserInteractionEnabled = false
        cell.minHeight = appearance.height
        cell.titleLabel.text = title
        cell.tintColor = appearance.tintColor
        cell.titleLabel?.textColor = appearance.textColor
        cell.titleLabel?.font = appearance.font
        cell.titleLabel?.textAlignment = appearance.textAlignment
        cell.messageLabel.text = message
        cell.messageLabel?.textColor = appearance.textColor
        cell.messageLabel?.font = titleAppearance?.messageTextFont
        cell.messageLabel?.textAlignment = appearance.textAlignment
    }
    
    func createCell(for tableView: UITableView) -> MinHeightTableViewCell {
        let identifier = type(of: self).className
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActionSheetTitleCell  ?? ActionSheetTitleCell.fromNib()
        return cell
    }
}
