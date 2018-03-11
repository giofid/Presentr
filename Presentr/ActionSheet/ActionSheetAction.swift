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
        cell.textLabel?.text = title
        cell.tintColor = appearance.tintColor
        cell.textLabel?.textColor = appearance.textColor
        cell.textLabel?.font = appearance.font
        cell.textLabel?.textAlignment = appearance.textAlignment
    }
    
    func createCell(for tableView: UITableView) -> MinHeightTableViewCell {
        let identifier = type(of: self).className
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? MinHeightTableViewCell  ?? MinHeightTableViewCell(style: .default, reuseIdentifier: identifier)
        return cell
    }
}
