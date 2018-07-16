//
//  ActionSheetAction.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

public typealias ActionSheetActionHandler = ((ActionSheetAction) -> Void)

/// Describes each action that is going to be shown in the 'ActionSheetController'
public class ActionSheetAction: ActionSheetItem {
    
    public let handler: ActionSheetActionHandler?
    
    /**
     Initialized an 'ActionSheetAction'
     
     - parameter title:   The title for the action, that will be used as the title for a row in the action sheet controller.
     - parameter image:   The image for the action, that will be used as an icon for the row in the action sheet controller.
     - parameter handler: The handler for the action, that will be called when the user clicks on a row in the action sheet controller.
     
     - returns: An inmutable ActionSheetAction object
     */
    public init(title: String, image: UIImage?, handler: ActionSheetActionHandler?) {
        self.handler = handler
        super.init(title: title, image: image)
        super.setup(delegate: self)
    }
}

extension ActionSheetAction: ActionSheetItemProtocol {
    
    func applyAppearance(_ appearance: ActionSheetAppearance) {
        self.appearance.applyAppearance(appearance.item)
    }
    
    func applyAppearance(to cell: MinHeightTableViewCell) {
        cell.minHeight = appearance.height
        cell.imageView?.image = image
        cell.tintColor = appearance.tintColor
        if let cell = cell as? ActionSheetItemCell {
            cell.titleLabel?.text = title
            cell.titleLabel?.textColor = appearance.textColor
            cell.titleLabel?.font = appearance.font
            cell.titleLabel?.textAlignment = appearance.textAlignment
        } else {
            cell.textLabel?.text = title
            cell.textLabel?.textColor = appearance.textColor
            cell.textLabel?.font = appearance.font
            cell.textLabel?.textAlignment = appearance.textAlignment
        }
    }

    func createCell(for tableView: UITableView) -> MinHeightTableViewCell {
        if appearance.textAlignment == .center {
            let identifier = type(of: self).className
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ActionSheetItemCell  ?? ActionSheetItemCell.fromNib()
            return cell
        } else {
            let identifier = type(of: self).className
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MinHeightTableViewCell  ?? MinHeightTableViewCell(style: .default, reuseIdentifier: identifier)
            return cell
        }
    }
}
