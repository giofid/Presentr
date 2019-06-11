//
//  ActionSheetItemCell.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 11/07/18.
//

import UIKit

class ActionSheetItemCell: MinHeightTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    class func fromNib<T : ActionSheetItemCell>() -> T {
        let name = "ActionSheetItemCell"
        let bundle = Bundle(for: self)
        guard let cell = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? T else {
            fatalError("Nib not found.")
        }
        return cell
    }
}
