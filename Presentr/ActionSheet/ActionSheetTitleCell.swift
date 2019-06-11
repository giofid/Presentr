//
//  ActionSheetTitleCell.swift
//  Presentr
//
//  Created by Giorgio Fiderio on 01/03/18.
//

import UIKit

class ActionSheetTitleCell: MinHeightTableViewCell {
 
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    class func fromNib<T : ActionSheetTitleCell>() -> T {
        let name = "ActionSheetTitleCell"
        let bundle = Bundle(for: self)
        guard let cell = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? T else {
            fatalError("Nib not found.")
        }
        return cell
    }
}
