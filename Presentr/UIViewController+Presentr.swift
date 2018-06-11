//
//  UIViewController+Presentr.swift
//  FirmaDigitale
//
//  Created by Giorgio Fiderio on 11/03/18.
//  Copyright © 2018 Aruba S.p.A. All rights reserved.
//

import UIKit

protocol PropertyStoring {
    
    associatedtype T
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
}

extension UIViewController: PropertyStoring {
    
    typealias T = Presentr

    private struct CustomProperties {
        
        static var menuPresentr: Presentr = {
            let center = ModalCenterPosition.bottom(percentage: 0.8, fixedWidth: false)
            let presentationType = PresentationType.dynamic(center: center)
            let presenter = Presentr(presentationType: presentationType)
            presenter.dismissOnSwipe = true
            return presenter
        }()
        
        static var actionSheetPresentr: Presentr = {
            let center = ModalCenterPosition.bottom(percentage: 0.8, fixedWidth: true)
            let presentationType = PresentationType.dynamic(center: center)
            let presenter = Presentr(presentationType: presentationType)
            presenter.dismissOnSwipe = false
            presenter.appearance.contentInset = 15
            presenter.appearance.roundCorners = true
            presenter.appearance.cornerRadius = 6
            presenter.appearance.actionSheet.item.textAlignment = .center
            presenter.appearance.actionSheet.title.textAlignment = .center
            presenter.appearance.actionSheet.item.shouldShowSeparator = true
            return presenter
        }()
        
        static var alertPresenter: Presentr = {
            let presenter = Presentr(presentationType: .dynamic(center: .center))
            presenter.transitionType = .crossDissolve
            presenter.dismissTransitionType = .crossDissolve
            presenter.dismissOnSwipe = false
            presenter.dismissOnTap = false
            presenter.appearance.contentInset = 15
            presenter.appearance.roundCorners = true
            presenter.appearance.cornerRadius = 6
            presenter.keyboardTranslationType = .stickToTop
            return presenter
        }()
    }
    
    public var menuPresentr: Presentr {
        return getAssociatedObject(&CustomProperties.menuPresentr, defaultValue: CustomProperties.menuPresentr)
    }
    
    public var actionSheetPresentr: Presentr {
        return getAssociatedObject(&CustomProperties.actionSheetPresentr, defaultValue: CustomProperties.actionSheetPresentr)
    }
    
    public var alertPresentr: Presentr {
        return getAssociatedObject(&CustomProperties.alertPresenter, defaultValue: CustomProperties.alertPresenter)
    }
}
