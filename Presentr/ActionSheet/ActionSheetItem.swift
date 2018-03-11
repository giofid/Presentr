//
//  ActionSheetItem.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 22/02/18.
//

import UIKit

extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
}

public class ActionSheetItem: NSObject {
    
    public let title: String?
    public let image: UIImage?
    
    open lazy var appearance: ActionSheetItemAppearance = {
        return ActionSheetItemAppearance(copy: PresentrAppearance.standard.actionSheet.item)
    }()
    
    private var delegate: ActionSheetItemProtocol!;
    
    internal init(title: String?, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    internal func setup(delegate: ActionSheetItemProtocol) {
        self.delegate = delegate;
    }
    
    func cell(for tableView: UITableView) -> UITableViewCell {
        let cell = delegate.createCell(for: tableView)
        delegate.applyAppearance(to: cell)
        return cell
    }
}

protocol ActionSheetItemProtocol {
    
    func applyAppearance(_ appearance: ActionSheetAppearance)
    func applyAppearance(to cell: MinHeightTableViewCell)
    func createCell(for tableView: UITableView) -> MinHeightTableViewCell
}
