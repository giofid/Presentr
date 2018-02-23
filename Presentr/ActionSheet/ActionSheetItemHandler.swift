//
//  ActionSheetItemHandler.swift
//  Presentr
//
//  Created by Giorgio Fiderio on on 22/02/18.
//

import UIKit

protocol ActionSheetItemHandlerDelegate: NSObjectProtocol {
    func handler(_ handler: ActionSheetItemHandler, didSelectItem: ActionSheetItem)
}

open class ActionSheetItemHandler: NSObject {
    
    weak var delegate: ActionSheetItemHandlerDelegate?
    
    // MARK: - Initialization
    
    init(collectionType: CollectionType) {
        self.collectionType = collectionType
    }
    
    // MARK: - Enum
    
    public enum CollectionType {
        case actions(actions: [ActionSheetAction])
//        case buttons
        case header(header: ActionSheetHeader)
    }
    
    
    // MARK: - Properties
    
    fileprivate var collectionType: CollectionType
    
    fileprivate var items: [ActionSheetItem] {
        switch collectionType {
//        case .buttons: return actionSheet?.buttons ?? []
        case .actions(let actions): return actions
        case .header(let header): return [header]
        }
    }
}


// MARK: - UITableViewDataSource

extension ActionSheetItemHandler: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return items[indexPath.row].cell(for: tableView)
    }
}


// MARK: - UITableViewDelegate

extension ActionSheetItemHandler: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.handler(self, didSelectItem: item)
        if let action = (item as? ActionSheetAction), let handler = action.handler {
            handler(action)
        }
    }
}
