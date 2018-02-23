//
//  ActionSheetHeader.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

/// Describes a header that is going to be shown in the 'ActionSheetController'
public class ActionSheetHeader: ActionSheetItem {
    
    public let subtitle: String?
    public let accessoryImage: UIImage?
    
    /**
     Initialized an 'ActionSheetHeader'
     
     - parameter title:   The title for the header, that will be used as the title for the header in the action sheet controller.
     - parameter subtitle:   The subtile for the header, that will be used as the subtitle for the header in the action sheet controller.
     - parameter image:   The image for the header, that will be used as an icon for the header in the action sheet controller.
     - parameter accessoryImage: The accessory image for the header, that will be used as an accessory image for the header in the action sheet controller.
     
     - returns: An inmutable ActionSheetHeader object
     */
    public init(title: String?, subtitle: String?, image: UIImage?, accessoryImage: UIImage?) {
        self.subtitle = subtitle
        self.accessoryImage = accessoryImage
        super.init(title: title, image: image)
        super.setup(delegate: self)
    }
}

extension ActionSheetHeader: ActionSheetItemProtocol {
    
    var headerAppearance: ActionSheetHeaderAppearance? {
        return appearance as? ActionSheetHeaderAppearance
    }
    
    func applyAppearance(to cell: MinHeightTableViewCell) {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        // usato al posto di cell.selectionStyle = .none perché altrimenti non funzionava il tap to dismiss
        cell.selectedBackgroundView = clearView
        cell.minHeight = headerAppearance?.height
        cell.backgroundColor = headerAppearance?.backgroundColor
        cell.textLabel?.text = title
        cell.textLabel?.font = headerAppearance?.font
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.font = headerAppearance?.detailTextFont
        cell.imageView?.image = image
        cell.accessoryView = UIImageView(image: accessoryImage)
        cell.textLabel?.textColor = headerAppearance?.textColor
        cell.detailTextLabel?.textColor = headerAppearance?.textColor
    }
    
    func createCell(for tableView: UITableView) -> MinHeightTableViewCell {
        let identifier = type(of: self).className
        let style: UITableViewCellStyle = (subtitle != nil) ? .subtitle : .default
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)  as? MinHeightTableViewCell ?? MinHeightTableViewCell(style: style, reuseIdentifier: identifier)
        return cell
    }
    
    func applyAppearance(_ appearance: PresentrAppearance) {
        self.appearance = ActionSheetHeaderAppearance(copy: appearance.header)
    }
}
